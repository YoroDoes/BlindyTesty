import 'package:hive/hive.dart';
import 'package:spotify/spotify.dart';

part 'spotify_credentials.g.dart';

@HiveType(typeId: 1)
class SpotifyCredentialsObject extends HiveObject {
  @HiveField(0)
  String? clientId;

  @HiveField(1)
  String? clientSecret;

  @HiveField(2)
  String? accessToken;

  @HiveField(3)
  String? refreshToken;

  @HiveField(4)
  String? tokenEndpoint;

  @HiveField(5)
  List<String>? scopes;

  @HiveField(6)
  DateTime? expiration;

  SpotifyCredentialsObject();

  /// Constructor from SpotifyApiCredentials
  SpotifyCredentialsObject.fromSpotifyApiCredentials(
      SpotifyApiCredentials credentials) {
    clientId = credentials.clientId;
    clientSecret = credentials.clientSecret;
    accessToken = credentials.accessToken;
    refreshToken = credentials.refreshToken;
    scopes = credentials.scopes;
    expiration = credentials.expiration;
    tokenEndpoint = credentials.tokenEndpoint.toString();
  }

  /// Converts this object to type SpotifyApiCredentials.
  SpotifyApiCredentials toSpotifyApiCredentials() {
    return SpotifyApiCredentials(
      clientId,
      clientSecret,
      accessToken: accessToken,
      refreshToken: refreshToken,
      scopes: scopes,
      expiration: expiration,
    );
  }
}
