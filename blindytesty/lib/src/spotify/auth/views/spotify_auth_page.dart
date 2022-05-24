import 'dart:io';

import 'package:blindytesty/src/services/providers/theme_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:blindytesty/src/platform/bloc/platform_bloc.dart';
import 'package:blindytesty/src/spotify/auth/bloc/spotify_auth_bloc.dart';
import 'package:blindytesty/src/services/storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blindytesty/src/drawer/drawer.dart';
import 'package:blindytesty/color_palettes.dart';
import 'package:provider/provider.dart';
import 'package:blindytesty/src/widgets/widgets.dart';
import 'package:blindytesty/src/spotify/mode/views/game_mode_selection.dart';

class SpotifyAuthView extends StatefulWidget {
  const SpotifyAuthView({Key? key}) : super(key: key);

  @override
  State<SpotifyAuthView> createState() => _SpotifyAuthViewState();
}

class _SpotifyAuthViewState extends State<SpotifyAuthView> {
  @override
  Widget build(BuildContext context) {
    if (kDebugMode) print('Launching Spotify View');
    return Consumer<ThemeProvider>(builder: (context, themeProvider, _) {
      return Scaffold(
        appBar: CustomAppBar(
          fullTitle: Hero(
            tag: 'logo',
            child: Image.asset(
              (themeProvider.selectedThemeMode == ThemeMode.dark)
                  ? "assets/spotify/Spotify_Logo_RGB_White.png"
                  : "assets/spotify/Spotify_Logo_RGB_Black.png",
              isAntiAlias: false,
              height: 40,
            ),
          ),
          backArrowAction: () {
            context.read<PlatformBloc>().add(PlatformUnset());
          },
          backgroundColor: Palette.spotify['green'],
          shadowColor: Palette.spotify['green'],
          foregroundColor: Palette.spotify['blackSolid'],
        ),
        drawer: const MenuDrawer(page: 'spotify'),
        body: BlocBuilder<SpotifyAuthBloc, SpotifyAuthState>(
          builder: (context, state) {
            if (kDebugMode) {
              print('rebuilding spotify view, SpotifyStatus: ${state.status}');
            }
            switch (state.status) {
              case SpotifyAuthStatus.connected:
                return const SpotifyGameModeSelectionView();
              case SpotifyAuthStatus.connecting:
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text(
                        'Connecting to spotify.',
                        style: TextStyle(fontSize: 30.0),
                      ),
                      Padding(padding: EdgeInsets.all(20.0)),
                      CircularProgressIndicator(),
                    ],
                  ),
                );
              default:
                if (Storage.spotifyCredentialsStorage
                    .containsKey('spotifyCredentials')) {
                  _tryToConnectToSpotify(context, state.status);
                  return const Center();
                } else {
                  return Center(
                    child: SelectionButton(
                      onPressed: () {
                        _tryToConnectToSpotify(context, state.status);
                      },
                      background: Palette.spotify['green'],
                      foreground: Palette.spotify['blackSolid'],
                      fontSize: 30,
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Image.asset(
                          "assets/spotify/Spotify_Icon_RGB_Black.png",
                          isAntiAlias: true,
                          height: 40,
                        ),
                        const Padding(padding: EdgeInsets.all(5)),
                        const Text('Connect to Spotify'),
                      ]),
                    ),
                  );
                }
            }
          },
        ),
      );
    });
  }

  _tryToConnectToSpotify(BuildContext context, currentStatus) async {
    try {
      context.read<SpotifyAuthBloc>().add(SpotifyAuthenticate(currentStatus));
    } on SocketException catch (e) {
      if (kDebugMode) {
        print('Socket Error: $e');
      }
    }
  }
}

class SpotifyAuthPage extends StatelessWidget {
  const SpotifyAuthPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(builder: (_) => const SpotifyAuthPage());
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('Spotify page bloc provider');
    }
    // return BlocProvider(
    //   create: (_) => SpotifyAuthBloc(),
    //   child: const SpotifyAuthView(),
    // );
    return const SpotifyAuthView();
  }
}
