import 'dart:convert';
// import 'dart:html' as html;
import 'dart:io';

import 'package:blindytesty/src/services/models/spotify_credentials.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:blindytesty/src/services/storage.dart';
import 'package:spotify/spotify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart'
    show Credentials, AuthorizationException, Client;
import 'package:html_messages/html_messages.dart';
import 'package:window_location_href/window_location_href.dart';

part 'spotify_auth_event.dart';
part 'spotify_auth_state.dart';

class SpotifyAuthBloc extends Bloc<SpotifyAuthEvent, SpotifyAuthState> {
  static const String _redirectUri = "http://127.0.0.1:2121/callback";
  static final String _webRedirectUri = kDebugMode
      ? "${getHref().toString()}callback.html"
      : "https://yorodoes.github.io/BlindyTesty/callback.html";
  static String get clientID => Storage.defaultSpotifyClientID;

  static const List<String> scopes = [
    'user-library-read',
  ];

  static const int fetchLimit = 50;

  static SpotifyApi? spotify;

  HttpServer? _callbackServer;

  SpotifyAuthBloc() : super(const SpotifyAuthState.unknown()) {
    on<SpotifyAuthenticate>(_onSpotifyAuthenticate);
    on<SpotifyDisconnect>(_onSpotifyDisconnect);
    on<SpotifyConnect>(_onSpotifyConnect);
  }

  static void _onCredentialsRefreshed(Credentials newCreds) {
    SpotifyApiCredentials newApiCreds = SpotifyApiCredentials(
      clientID,
      null,
      accessToken: newCreds.accessToken,
      refreshToken: newCreds.refreshToken,
      scopes: newCreds.scopes,
      expiration: newCreds.expiration,
    );
    Storage.setSpotifyCredentials(
        SpotifyCredentialsObject.fromSpotifyApiCredentials(newApiCreds));
    if (newCreds.refreshToken != null) {
      if (kDebugMode) {
        print('Refresh token has been refreshed automatically.');
      }
    }
  }

  _onSpotifyAuthenticate(
    SpotifyAuthenticate event,
    Emitter<SpotifyAuthState> emit,
  ) async {
    SpotifyAuthStatus status = SpotifyAuthStatus.connecting;
    emit(SpotifyAuthState(status: status));

    // try to reconnect from stored credentials
    if (Storage.spotifyCredentialsStorage.containsKey('spotifyCredentials')) {
      SpotifyApiCredentials creds = Storage.spotifyCredentialsStorage
          .get('spotifyCredentials')!
          .toSpotifyApiCredentials();

      Credentials credentials = Credentials(
        creds.accessToken!,
        refreshToken: creds.refreshToken,
        idToken: creds.clientId,
        tokenEndpoint: creds.tokenEndpoint,
        scopes: creds.scopes,
        expiration: creds.expiration,
      );
      Client client = Client(
        credentials,
        identifier: clientID,
        secret: null,
        basicAuth: true,
        httpClient: http.Client(),
        onCredentialsRefreshed: _onCredentialsRefreshed,
      );

      spotify = SpotifyApi.fromClient(client);
      // status = SpotifyStatus.connected;
      add(const SpotifyConnect());
    } else {
      // auth in spotify
      final credentials = SpotifyApiCredentials(clientID, null);
      final grant = SpotifyApi.authorizationCodeGrant(credentials);

      //Create the authUri
      // final href = getHref();
      // String? redirect = href ?? _redirectUri;
      // if (href != null) {
      //   print(href);
      // }
      final authUri = grant.getAuthorizationUrl(
        Uri.parse(kIsWeb ? _webRedirectUri : _redirectUri),
        scopes: scopes,
      );

      try {
        // response to spotify connection callback

        HtmlMessages.registerOnMessage('blindytestyCallback', (message) async {
          if (kDebugMode) {
            print('${message.data}');
          }
          final resultJson = jsonDecode(message.data.toString());
          if (resultJson['result'] == 'error') {
            add(const SpotifyDisconnect());
          } else if (resultJson['result'] == 'code') {
            try {
              spotify = SpotifyApi.fromAuthCodeGrant(
                  grant, resultJson['callbackUri']);
              Storage.setSpotifyCredentials(
                SpotifyCredentialsObject.fromSpotifyApiCredentials(
                    await spotify!.getCredentials()),
              );
              add(const SpotifyConnect());
              // add(const SpotifyConnect());
            } on AuthorizationException catch (e) {
              if (kDebugMode) {
                print('Auth exception: $e');
              }
            } on FormatException catch (e) {
              if (kDebugMode) {
                print('Format exception: $e');
              }
            } on Exception catch (e) {
              if (kDebugMode) {
                print('Exception during authentication: $e');
              }
            }
          }
        });

        if (!kIsWeb && _callbackServer == null) {
          _callbackServer = await HttpServer.bind('127.0.0.1', 2121);
          _callbackServer?.forEach((HttpRequest request) async {
            if (request.requestedUri.toString().startsWith(_redirectUri)) {
              if (request.uri.queryParameters.containsKey('error')) {
                request.response.statusCode = HttpStatus.ok;
                request.response.write(
                    'You did not connect, close this page and try again.');
                // access denied
                add(const SpotifyDisconnect());
              } else if (request.uri.queryParameters.containsKey('code')) {
                // connected?
                try {
                  spotify = SpotifyApi.fromAuthCodeGrant(
                      grant, request.requestedUri.toString());
                  Storage.setSpotifyCredentials(
                    SpotifyCredentialsObject.fromSpotifyApiCredentials(
                      await spotify!.getCredentials(),
                    ),
                  );
                  request.response.statusCode = HttpStatus.ok;
                  request.response
                      .write('You are connected, you can close this page.');
                  // status = SpotifyStatus.connected;
                  add(const SpotifyConnect());
                } on AuthorizationException catch (e) {
                  if (kDebugMode) {
                    print('Auth exception: $e');
                  }
                } on FormatException catch (e) {
                  if (kDebugMode) {
                    print('Format exception: $e');
                  }
                } on Exception catch (e) {
                  if (kDebugMode) {
                    print('Exception during authentication: $e');
                  }
                }
              } else {
                if (kDebugMode) {
                  print('Path: ${request.uri.path} is not recognized.');
                }
                request.response.statusCode = HttpStatus.badRequest;
              }
              request.response.close();
              if (Platform.isIOS || Platform.isAndroid) closeInAppWebView();
            }
          });
        }

        // launch spotify connection window
        if (!await launchUrl(authUri)) {
          throw "Could not launch $authUri";
        }
      } catch (e) {
        if (kDebugMode) {
          print("$e");
        }
      }
    }
  }

  _onSpotifyDisconnect(
    SpotifyDisconnect event,
    Emitter<SpotifyAuthState> emit,
  ) {
    Storage.deleteSpotifyCredentials();
    emit(SpotifyAuthState(status: event.status));
  }

  _onSpotifyConnect(
    SpotifyConnect event,
    Emitter<SpotifyAuthState> emit,
  ) {
    emit(SpotifyAuthState(status: event.status));
  }
}
