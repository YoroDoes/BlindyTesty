import 'dart:async';

import 'package:blindytesty/color_palettes.dart';
import 'package:blindytesty/src/drawer/drawer.dart';
import 'package:blindytesty/src/spotify/auth/bloc/spotify_auth_bloc.dart';
import 'package:blindytesty/src/spotify/game/bloc/spotify_game_bloc.dart';
import 'package:blindytesty/src/spotify/game/models/models.dart';
import 'package:blindytesty/src/spotify/game/views/common_game.dart';
import 'package:blindytesty/src/spotify/game/views/playlist_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blindytesty/src/widgets/appbar.dart';

class SpotifyPlaylistGameModeView extends StatefulWidget {
  const SpotifyPlaylistGameModeView({Key? key}) : super(key: key);

  @override
  State<SpotifyPlaylistGameModeView> createState() =>
      _SpotifyPlaylistGameModeViewState();
}

class _SpotifyPlaylistGameModeViewState
    extends State<SpotifyPlaylistGameModeView> {
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
              ' - Playlist mode',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backArrowAction: () {
          _loadingStream?.cancel();
          if (context.read<SpotifyGameBloc>().state.playlistID == null) {
            Navigator.of(context).pop();
          } else {
            BlocProvider.of<SpotifyGameBloc>(context)
                .add(SpotifyGamePlaylistReset());
          }
        },
        backgroundColor: Palette.spotify['green'],
        shadowColor: Palette.spotify['green'],
        foregroundColor: Palette.spotify['blackSolid'],
      ),
      drawer: const MenuDrawer(page: 'spotify'),
      body: BlocBuilder<SpotifyGameBloc, SpotifyGameState>(
        buildWhen: (previous, current) =>
            previous.playlistID != current.playlistID,
        builder: (context, state) {
          switch (state.playlistID) {
            case null:
              return BlocProvider.value(
                value: BlocProvider.of<SpotifyGameBloc>(context),
                child: const SpotifyPlaylistSelectionView(),
              );
            default:
              ValueNotifier<String> _playlistName = ValueNotifier<String>('');
              SpotifyAuthBloc.spotify?.playlists
                  .get(state.playlistID!)
                  .then((playlist) {
                _playlistName.value = playlist.name!;
                BlocProvider.of<SpotifyGameBloc>(context).add(
                    SpotifyGamePlaylistLoadTotal(
                        playlistLoadTotal: playlist.tracks!.total!));
              });
              ValueNotifier<bool> _coverLoaded = ValueNotifier<bool>(false);
              Image? _playlistCover;
              SpotifyAuthBloc.spotify?.playlists
                  .get(state.playlistID!)
                  .then((playlist) {
                _playlistCover = Image.network(
                  playlist.images!.first.url!,
                  height: 200.0,
                );
                _coverLoaded.value = true;
              });
              return BlocBuilder<SpotifyGameBloc, SpotifyGameState>(
                buildWhen: (previous, current) =>
                    previous.playlistLoadComplete !=
                    current.playlistLoadComplete,
                builder: (context, state) {
                  if (state.playlistLoadComplete != true) {
                    // Loading songs
                    _loadingStream = SpotifyAuthBloc.spotify?.playlists
                        .getTracksByPlaylistId(state.playlistID)
                        .stream(50)
                        .listen((page) {
                      //add tracks
                      BlocProvider.of<SpotifyGameBloc>(context).add(
                        SpotifyGamePlaylistLoadTracks(
                          tracks: page.items!.map(
                            (e) {
                              return Song(track: e);
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
                      child: ValueListenableBuilder<String>(
                        builder: (context, playlistName, child) {
                          if (playlistName == '') {
                            return const CircularProgressIndicator();
                          } else {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ValueListenableBuilder<bool>(
                                  builder: (context, loaded, child) {
                                    if (!loaded) {
                                      return const CircularProgressIndicator();
                                    } else {
                                      return _playlistCover!;
                                    }
                                  },
                                  valueListenable: _coverLoaded,
                                ),
                                Text(
                                  'Loading tracks for playlist $playlistName',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
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
                                          const Text(
                                              'Failed to load this playlist.'),
                                          ElevatedButton(
                                              onPressed: () {
                                                BlocProvider.of<
                                                            SpotifyGameBloc>(
                                                        context)
                                                    .add(
                                                        SpotifyGamePlaylistReset());
                                              },
                                              child: const Text(
                                                  'Return to mode selection')),
                                        ],
                                      );
                                    } else {
                                      return const Center();
                                    }
                                  },
                                ),
                              ],
                            );
                          }
                        },
                        valueListenable: _playlistName,
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
          }
        },
      ),
    );
  }
}

class SpotifyPlaylistGameModePage extends StatelessWidget {
  const SpotifyPlaylistGameModePage({Key? key}) : super(key: key);

  static MaterialPageRoute route() => MaterialPageRoute(
        builder: (context) => const SpotifyPlaylistGameModePage(),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SpotifyGameBloc>(
      create: (_) => SpotifyGameBloc(),
      child: const SpotifyPlaylistGameModeView(),
    );
  }
}
