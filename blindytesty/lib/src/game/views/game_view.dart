import 'dart:async';

import 'package:blindytesty/color_palettes.dart';
import 'package:blindytesty/src/game/bloc/game_bloc.dart';
import 'package:blindytesty/src/game/models/models.dart';
import 'package:blindytesty/src/game/views/views.dart';
import 'package:blindytesty/src/platform/platform.dart';
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
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _stopPlayers();
    WidgetsBinding.instance.removeObserver(this);
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
    final GlobalKey<FormState> guessFormKey = GlobalKey<FormState>();
    TextEditingController guessFormController = TextEditingController();
    FocusNode guessFocusNode = FocusNode();
    StreamSubscription? trackPositionSubscription;
    Song? currentTrack;

    if (kDebugMode) {
      print('Building Game');
    }
    tracks = context
        .select<GameBloc, List<Song>>((GameBloc bloc) => bloc.state.tracks);
    return BlocBuilder<GameBloc, GameState>(
      buildWhen: (previous, current) =>
          previous.rulesShown != current.rulesShown,
      builder: (context, state) {
        if (state.rulesShown != true) {
          return BlocProvider.value(
            value: BlocProvider.of<GameBloc>(context),
            child: const RulesView(),
          );
        } else {
          return Center(
            child: BlocBuilder<GameBloc, GameState>(
              buildWhen: (previous, current) {
                return (previous.gameOver != current.gameOver) ||
                    (previous.guessing != current.guessing);
              },
              builder: (context, state) {
                if (state.gameOver) {
                  // Game is over
                  final finalScore =
                      BlocProvider.of<GameBloc>(context).state.score;
                  double? maxScore =
                      BlocProvider.of<GameBloc>(context).state.maxScore;
                  context.select((GameBloc gameBloc) {
                    maxScore = ((gameBloc.state.trackCount) -
                                (gameBloc.state.tracks.length))
                            .toDouble() *
                        (gameBloc.state.fields.values
                            .reduce((value, element) => value + element.score));
                  });
                  return Column(
                    children: [
                      Text('Game is done, you scored '
                          '$finalScore/$maxScore'),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Go back'),
                      ),
                    ],
                  );
                } else {
                  // Game is not over
                  if (state.guessing) {
                    // Taking a guess
                    if (tracks?.isEmpty ?? true) {
                      //fail safe
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Your track list is empty, this might be an internal error.',
                            ),
                            ElevatedButton(
                              onPressed: () {
                                BlocProvider.of<PlatformBloc>(context)
                                    .add(PlatformUnset());
                              },
                              child: const Text('Return to platform selection'),
                            ),
                          ],
                        ),
                      );
                    }
                    currentTrack = tracks?.first;
                    Future<void>(() async {
                      await currentTrack?.play();
                      trackPositionSubscription =
                          currentTrack?.streams?.position.listen((position) {
                        try {
                          BlocProvider.of<GameBloc>(context)
                              .add(GameGuessProgress(
                            elapsedTime: position.inMilliseconds,
                            totalTime:
                                currentTrack?.duration.inMilliseconds ?? 99999,
                            playing: currentTrack?.controller?.playing ?? false,
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
                            '${BlocProvider.of<GameBloc>(context).state.currentTrack}'
                            '/'
                            '${BlocProvider.of<GameBloc>(context).state.trackCount}'),
                        // Countdown
                        BlocBuilder<GameBloc, GameState>(
                          buildWhen: (previous, current) =>
                              (previous.elapsedTime != current.elapsedTime),
                          builder: (context, state) {
                            int elapsedTime = state.elapsedTime;
                            int remainingTime =
                                ((currentTrack!.duration.inMilliseconds -
                                            elapsedTime) /
                                        1000)
                                    .ceil();
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                CircularProgressIndicator(
                                  value: elapsedTime /
                                      currentTrack!.duration.inMilliseconds,
                                ),
                                Text('$remainingTime'),
                              ],
                            );
                          },
                        ),
                        // Right answers
                        BlocBuilder<GameBloc, GameState>(
                          buildWhen: (previous, current) =>
                              previous.fields != current.fields,
                          builder: (context, state) {
                            String result = state.fieldsFormat.replaceAllMapped(
                                RegExp(r'{(\w*)}'),
                                (match) =>
                                    "${state.fields[match[1]].guessed ? '*****' : state.fields[match[1]].answer}");
                            return Text(result);
                          },
                        ),
                        Form(
                          key: guessFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Input Text
                              TextFormField(
                                controller: guessFormController,
                                autofocus: true,
                                focusNode: guessFocusNode,
                                decoration: const InputDecoration(
                                  hintText: 'Enter artist or song name.',
                                ),
                                onFieldSubmitted: (value) {
                                  if (guessFormKey.currentState!.validate()) {
                                    BlocProvider.of<GameBloc>(context)
                                        .add(GameGuess(guess: value));
                                    guessFormController.text = '';
                                    Timer(const Duration(milliseconds: 1), () {
                                      guessFocusNode.requestFocus();
                                    });
                                  }
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
                                  if (guessFormKey.currentState!.validate()) {
                                    BlocProvider.of<GameBloc>(context)
                                        .add(GameGuess(
                                      guess: guessFormController.text,
                                    ));
                                  }
                                  guessFormController.text = '';
                                  guessFocusNode.requestFocus();
                                },
                                child: const Text('Take a guess'),
                              ),
                              // Skip Button
                              ElevatedButton(
                                onPressed: () {
                                  BlocProvider.of<GameBloc>(context)
                                      .add(const GameSkipGuess());
                                  guessFormController.text = '';
                                },
                                child: const Text('Skip this song'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    // Results
                    double score =
                        BlocProvider.of<GameBloc>(context).state.guessScore;
                    _stopPlayers();
                    trackPositionSubscription?.cancel();
                    guessFormController.text = '';

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            BlocProvider.of<GameBloc>(context)
                                .add(const GameOver());
                          },
                          child: const Text('Stop game now'),
                        ),
                        // Cover
                        tracks!.first.cover ?? const Center(),
                        // Song - Artist
                        Builder(
                          builder: (context) {
                            final fields =
                                BlocProvider.of<GameBloc>(context).state.fields;
                            final fledStyle = fields.map(
                              (key, value) => MapEntry(
                                key,
                                TextStyle(
                                  color: value.guessed
                                      ? Colors.green.shade400
                                      : null,
                                ),
                              ),
                            );
                            final spans = <TextSpan>[];
                            RegExp(r'(?:{(?<field>\w+)})?(?<separation>[^{]*)')
                                .allMatches(BlocProvider.of<GameBloc>(context)
                                    .state
                                    .fieldsFormat)
                                .forEach((match) {
                              if (match.namedGroup('field')?.isNotEmpty ??
                                  false) {
                                spans.add(
                                  TextSpan(
                                    text: fields[match.namedGroup('field')],
                                    style: fledStyle[match.namedGroup('field')],
                                  ),
                                );
                              }
                              if (match.namedGroup('separation')?.isNotEmpty ??
                                  false) {
                                spans.add(
                                  TextSpan(
                                    text: match.namedGroup('separation'),
                                  ),
                                );
                              }
                            });
                            return SelectableText.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'Answer: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  ...spans,
                                ],
                              ),
                            );
                          },
                        ),
                        // Score
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Score: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('$score'),
                          ],
                        ),
                        // Next song (popping first song in the process)
                        RawKeyboardListener(
                          focusNode: FocusNode()..requestFocus(),
                          onKey: (event) {
                            if (event.isKeyPressed(LogicalKeyboardKey.enter) ||
                                event.isKeyPressed(LogicalKeyboardKey.space) ||
                                event.isKeyPressed(LogicalKeyboardKey.accept)) {
                              BlocProvider.of<GameBloc>(context)
                                  .add(const GameNextGuess());
                            }
                          },
                          child: ElevatedButton(
                            onPressed: () {
                              BlocProvider.of<GameBloc>(context)
                                  .add(const GameNextGuess());
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
