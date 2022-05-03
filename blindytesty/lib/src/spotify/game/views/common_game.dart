import 'dart:async';

import 'package:blindytesty/color_palettes.dart';
import 'package:blindytesty/src/spotify/game/bloc/spotify_game_bloc.dart';
import 'package:blindytesty/src/spotify/game/models/models.dart';
import 'package:blindytesty/src/spotify/game/views/rules.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kplayer/kplayer.dart' as kplayer;

class SpotifyCommonGameView extends StatefulWidget {
  const SpotifyCommonGameView({Key? key}) : super(key: key);

  @override
  State<SpotifyCommonGameView> createState() => _SpotifyCommonGameViewState();
}

class _SpotifyCommonGameViewState extends State<SpotifyCommonGameView>
    with WidgetsBindingObserver {
  List<Song>? tracks;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    _stopPlayers();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        _pausePlayers();
        break;
      case AppLifecycleState.resumed:
        _resumePlayers();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.detached:
        _stopPlayers();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // return BlocBuilder<SpotifyGameBloc, SpotifyGameState>(
    //   builder: (context, state) {
    final GlobalKey<FormState> _guessFormKey = GlobalKey<FormState>();
    TextEditingController _guessFormController = TextEditingController();
    FocusNode _guessFocusNode = FocusNode();
    StreamSubscription? _currentTrackStreamSubscription;
    Song? currentTrack;

    if (kDebugMode) {
      print('Building Game');
    }
    tracks = context.select<SpotifyGameBloc, List<Song>>(
        (SpotifyGameBloc bloc) => bloc.state.tracks!);
    return BlocBuilder<SpotifyGameBloc, SpotifyGameState>(
      buildWhen: (previous, current) =>
          previous.rulesShown != current.rulesShown,
      builder: (context, state) {
        if (state.rulesShown != true) {
          return BlocProvider.value(
            value: BlocProvider.of<SpotifyGameBloc>(context),
            child: const RulesView(),
          );
        } else {
          return Center(
            child: BlocBuilder<SpotifyGameBloc, SpotifyGameState>(
              buildWhen: (previous, current) {
                return (previous.gameOver != current.gameOver) ||
                    (previous.guessing != current.guessing);
              },
              builder: (context, state) {
                if (state.gameOver!) {
                  final finalScore =
                      BlocProvider.of<SpotifyGameBloc>(context).state.score;
                  final maxScore =
                      BlocProvider.of<SpotifyGameBloc>(context).state.maxScore;
                  return Column(
                    children: [
                      Text('Game is done, you scored '
                          '$finalScore/$maxScore'),
                      ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<SpotifyGameBloc>(context)
                              .add(SpotifyGamePlaylistReset());
                        },
                        child: const Text('Go back'),
                      ),
                    ],
                  );
                } else {
                  // Game is not over
                  if (state.guessing!) {
                    // Taking a guess
                    if (tracks!.isEmpty) {
                      //fail safe
                      //TODO emit game done
                      BlocProvider.of<SpotifyGameBloc>(context)
                          .add(SpotifyGamePlaylistReset());
                    }
                    currentTrack = tracks?.first;
                    Future<void>(() async {
                      await currentTrack?.play();
                      _currentTrackStreamSubscription =
                          currentTrack?.streams.position.listen((position) {
                        try {
                          print(position.inMilliseconds);
                          BlocProvider.of<SpotifyGameBloc>(context)
                              .add(SpotifyGamePlaylistGuessProgress(
                            elapsedTime: position.inMilliseconds,
                            totalTime: (currentTrack!.duration),
                          ));
                        } catch (e) {
                          if (kDebugMode) {
                            print(e);
                          }
                        }
                      });
                    });
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            '${BlocProvider.of<SpotifyGameBloc>(context).state.currentTrack}'
                            '/'
                            '${BlocProvider.of<SpotifyGameBloc>(context).state.trackCount}'),
                        // Countdown
                        BlocBuilder<SpotifyGameBloc, SpotifyGameState>(
                          buildWhen: (previous, current) =>
                              (previous.elapsedTime != current.elapsedTime),
                          builder: (context, state) {
                            int elapsedTime = state.elapsedTime ?? 0;
                            int remainingTime =
                                ((currentTrack!.duration - elapsedTime) / 1000)
                                    .ceil();
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                CircularProgressIndicator(
                                  value: elapsedTime / currentTrack!.duration,
                                  color: Palette.spotify['green'],
                                  backgroundColor: Palette.spotify['greySolid'],
                                ),
                                Text('$remainingTime'),
                              ],
                            );
                          },
                        ),
                        // Right answers
                        BlocBuilder<SpotifyGameBloc, SpotifyGameState>(
                          buildWhen: (previous, current) =>
                              (previous.artistGuessed !=
                                  current.artistGuessed) ||
                              (previous.songGuessed != current.songGuessed),
                          builder: (context, state) {
                            String unknown = '*****';
                            String artist = (state.artistGuessed == true)
                                ? currentTrack!.artistToGuess
                                : unknown;
                            String song = (state.songGuessed == true)
                                ? currentTrack!.name
                                : unknown;
                            return Text('$song by $artist');
                          },
                        ),
                        Form(
                          key: _guessFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Input Text
                              TextFormField(
                                controller: _guessFormController,
                                autofocus: true,
                                focusNode: _guessFocusNode,
                                decoration: const InputDecoration(
                                  hintText:
                                      'Enter artist or song name, or both.',
                                ),
                                onFieldSubmitted: (value) {
                                  BlocProvider.of<SpotifyGameBloc>(context)
                                      .add(SpotifyGamePlaylistGuess(
                                    guess: value,
                                  ));
                                  _guessFormController.text = '';
                                  Timer(const Duration(milliseconds: 1), () {
                                    _guessFocusNode.requestFocus();
                                  });
                                },
                                validator: (String? value) {
                                  return (value == null || value.isEmpty)
                                      ? 'Enter Text wesh'
                                      : null;
                                },
                              ),
                              // Guess Button
                              ElevatedButton(
                                onPressed: () {
                                  if (_guessFormKey.currentState!.validate()) {
                                    BlocProvider.of<SpotifyGameBloc>(context)
                                        .add(SpotifyGamePlaylistGuess(
                                      guess: _guessFormController.text,
                                    ));
                                  }
                                  _guessFormController.text = '';
                                  _guessFocusNode.requestFocus();
                                },
                                child: const Text('Take a guess'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    // Results
                    double score = BlocProvider.of<SpotifyGameBloc>(context)
                            .state
                            .guessScore ??
                        0;
                    _stopPlayers();
                    _currentTrackStreamSubscription?.cancel();

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Cover
                        tracks!.first.cover!,
                        // Song - Artist
                        //TODO Make guessed text green or something
                        Text('Answer: '
                            '${tracks!.first.name} by ${tracks!.first.artistToGuess}'),
                        // Score
                        Text(
                          'Score: '
                          '$score',
                        ),
                        // Next song (popping first song in the process)
                        RawKeyboardListener(
                          focusNode: FocusNode()..requestFocus(),
                          onKey: (event) {
                            if (event.isKeyPressed(LogicalKeyboardKey.enter) ||
                                event.isKeyPressed(LogicalKeyboardKey.space) ||
                                event.isKeyPressed(LogicalKeyboardKey.accept)) {
                              BlocProvider.of<SpotifyGameBloc>(context)
                                  .add(SpotifyGamePlaylistNextGuess());
                            }
                          },
                          child: ElevatedButton(
                            onPressed: () {
                              BlocProvider.of<SpotifyGameBloc>(context)
                                  .add(SpotifyGamePlaylistNextGuess());
                            },
                            child: const Text('Next song'),
                          ),
                        ),
                      ],
                    );
                  }
                }
              },
            ),
          );
        }
      },
    );
    //   },
    // );
  }

  Future<void> _stopPlayers() async {
    for (var player in kplayer.PlayerController.palyers) {
      player.stop();
    }
  }

  Future<void> _pausePlayers() async {
    for (var player in kplayer.PlayerController.palyers) {
      if (player.status != kplayer.PlayerStatus.stopped) player.pause();
    }
  }

  Future<void> _resumePlayers() async {
    for (var player in kplayer.PlayerController.palyers) {
      if (player.status == kplayer.PlayerStatus.paused) player.play();
    }
  }
}
