import 'dart:async';

import 'package:blindytesty/color_palettes.dart';
import 'package:blindytesty/src/drawer/drawer.dart';
import 'package:blindytesty/src/spotify/auth/bloc/spotify_auth_bloc.dart';
import 'package:blindytesty/src/spotify/game/bloc/spotify_game_bloc.dart';
import 'package:blindytesty/src/spotify/game/models/models.dart';
import 'package:blindytesty/src/spotify/game/views/common_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blindytesty/src/widgets/appbar.dart';

class SpotifyLikedGameModeView extends StatefulWidget {
  const SpotifyLikedGameModeView({Key? key}) : super(key: key);

  @override
  State<SpotifyLikedGameModeView> createState() =>
      _SpotifyLikedGameModeViewState();
}

class _SpotifyLikedGameModeViewState extends State<SpotifyLikedGameModeView> {
  StreamSubscription? _loadingStream;

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<SpotifyGameBloc>(context).add(SpotifyGamePlaylistReset());
    return Scaffold(
      appBar: CustomAppBar(
        fullTitle: Row(
          children: [
            Image.asset(
              "assets/spotify/Spotify_Logo_RGB_Black.png",
              isAntiAlias: false,
              height: 40,
            ),
            const Text(
              ' - Liked songs mode',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backArrowAction: () {
          _loadingStream?.cancel();
          Navigator.of(context).pop();
        },
        backgroundColor: Palette.spotify['green'],
        shadowColor: Palette.spotify['green'],
        foregroundColor: Palette.spotify['blackSolid'],
      ),
      drawer: const MenuDrawer(page: 'spotify'),
      body: Builder(
        builder: (context) {
          SpotifyAuthBloc.spotify?.tracks.me.saved.first().then((songsPage) {
            BlocProvider.of<SpotifyGameBloc>(context).add(
                SpotifyGamePlaylistLoadTotal(
                    playlistLoadTotal: songsPage.metadata.total ?? 0));
          });
          return BlocBuilder<SpotifyGameBloc, SpotifyGameState>(
            buildWhen: (previous, current) =>
                previous.playlistLoadComplete != current.playlistLoadComplete,
            builder: (context, state) {
              if (state.playlistLoadComplete != true) {
                // Loading songs
                _loadingStream = SpotifyAuthBloc.spotify?.tracks.me.saved
                    .stream(50)
                    .listen((page) {
                  //add tracks
                  BlocProvider.of<SpotifyGameBloc>(context).add(
                    SpotifyGamePlaylistLoadTracks(
                      tracks: page.items!.map(
                        (e) {
                          return Song(track: e.track!);
                        },
                      ).toList()
                        ..removeWhere(
                          (song) => song.track.previewUrl == null,
                        ),
                    ),
                  );
                })
                  ?..onDone(() {
                    BlocProvider.of<SpotifyGameBloc>(context)
                        .add(SpotifyGamePlaylistLoadDone());
                  });
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Loading saved tracks.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(10)),
                      BlocBuilder<SpotifyGameBloc, SpotifyGameState>(
                        buildWhen: (previous, current) =>
                            previous.playlistLoadProgress !=
                            current.playlistLoadProgress,
                        builder: (context, state) {
                          if (state.playlistLoadProgress == null) {
                            return const CircularProgressIndicator();
                          } else {
                            return LinearProgressIndicator(
                              value: state.playlistLoadProgress! /
                                  state.playlistLoadTotal!,
                            );
                          }
                        },
                      ),
                      BlocBuilder<SpotifyGameBloc, SpotifyGameState>(
                        buildWhen: (previous, current) =>
                            previous.playlistLoadFailed !=
                            current.playlistLoadFailed,
                        builder: (context, state) {
                          if (state.playlistLoadFailed == true) {
                            return Column(
                              children: [
                                const Text('Failed to load this playlist.'),
                                ElevatedButton(
                                    onPressed: () {
                                      BlocProvider.of<SpotifyGameBloc>(context)
                                          .add(SpotifyGamePlaylistReset());
                                    },
                                    child:
                                        const Text('Return to mode selection')),
                              ],
                            );
                          } else {
                            return const Center();
                          }
                        },
                      ),
                    ],
                  ),
                );
              } else {
                // Game start
                return BlocProvider.value(
                  value: BlocProvider.of<SpotifyGameBloc>(context),
                  child: const SpotifyCommonGameView(),
                );
              }
            },
          );
        },
      ),
    );
  }
}

class SpotifyLikedGameModePage extends StatelessWidget {
  const SpotifyLikedGameModePage({Key? key}) : super(key: key);

  static MaterialPageRoute route() => MaterialPageRoute(
        builder: (context) => const SpotifyLikedGameModePage(),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SpotifyGameBloc>(
      create: (_) => SpotifyGameBloc(),
      child: const SpotifyLikedGameModeView(),
    );
  }
}
