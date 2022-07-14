import 'dart:math';

import 'package:blindytesty/src/game/models/models.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  static const rules = <String, String>{
    'spotify': 'Spotify rules',
    'youtube': 'Youtube rules',
    'local': 'Local rules',
  };

  GameBloc() : super(const GameState()) {
    on<GameRulesShown>(_onGameRulesShown);
    on<GameGuessProgress>(_onGameGuessProgress);
    on<GameGuess>(_onGameGuess);
    on<GameSkipGuess>(_onGameSkipGuess);
    on<GameNextGuess>(_onGameNextGuess);
    on<GameOver>(_onGameOver);
  }

  void _onGameRulesShown(GameRulesShown event, Emitter<GameState> emit) {
    emit(GameState.fromState(
      state,
      rulesShown: true,
    ));
  }

  void _onGameGuessProgress(GameGuessProgress event, Emitter<GameState> emit) {
    bool guessing = state.guessing;
    if (event.elapsedTime >= event.totalTime || !event.playing) {
      guessing = false;
    }

    print(
        '${event.elapsedTime}, ${event.totalTime} $guessing ${event.playing}');

    emit(GameState.fromState(
      state,
      elapsedTime: event.elapsedTime,
      guessing: guessing,
    ));
  }

  void _onGameGuess(GameGuess event, Emitter<GameState> emit) {
    double score = 0;
    var tracks = state.tracks;
    score = _guess(event.guess, tracks);

    emit(GameState.fromState(
      state,
      tracks: tracks,
      guessing: tracks.any(
        (track) => !track.fields.values.any(
          (field) => !field.guessed,
        ),
      ),
      guessScore: state.guessScore + score,
    ));
  }

  void _onGameSkipGuess(GameSkipGuess event, Emitter<GameState> emit) {
    emit(GameState.fromState(
      state,
      guessing: false,
    ));
  }

  void _onGameNextGuess(GameNextGuess event, Emitter<GameState> emit) {
    //TODO replace the list removal to avoid changing the list while it is being processed in the background
    double score = (state.score) + (state.guessScore);
    state.tracks.removeAt(0);
    emit(GameState.fromState(
      state,
      score: score,
      guessScore: 0,
      elapsedTime: 0,
      guessing: true,
      currentTrack: state.currentTrack + 1,
      gameOver: state.tracks.isEmpty,
    ));
  }

  void _onGameOver(GameOver event, Emitter<GameState> emit) {
    double score = (state.score) + (state.guessScore);
    state.tracks.removeAt(0);
    emit(GameState.fromState(
      state,
      score: score,
      gameOver: true,
    ));
  }

  /// Utilities
  double _guess(String guess, List<Song> tracks) {
    String ignoreStuff(String str) {
      return str
          .split(' - ')
          .first
          .replaceAll(RegExp(r' *\([^\)]*\) *'), '')
          .replaceAll(RegExp(r'( and | et | y | или )'), '&')
          .replaceAll(
              RegExp('[’\'"()\\[\\]{}<>:,‒–—―…!\\.«»-‐\\?‘’“”;/⁄␠·'
                  '&@*\\•^¤¢\$€£¥₩₪†‡°¡¿¬#№%‰‱¶′§'
                  '~¨_|¦⁂☞∴‽※〜「」、。・；：’”￥！＠＃＄％＾＆＊（）＜＞\\？｜\\+]'),
              '');
    }

    int getTextDistance(String a, String b) {
      if (a.isEmpty) return b.length;
      if (b.isEmpty) return a.length;

      List<List<int>> matrix = List<List<int>>.filled(b.length + 1, []);

      // increment along the first column of each row
      int i;
      for (i = 0; i <= b.length; i++) {
        matrix.setRange(i, i + 1, [List<int>.filled(a.length + 1, i)]);
      }

      // increment each column in the first row
      int j;
      for (j = 0; j <= a.length; j++) {
        matrix[0][j] = j;
      }

      // Fill in the rest of the matrix
      for (i = 1; i <= b.length; i++) {
        for (j = 1; j <= a.length; j++) {
          if (b.substring(i - 1, i) == a.substring(j - 1, j)) {
            matrix[i][j] = matrix[i - 1][j - 1];
          } else {
            matrix[i][j] = min<int>(
                matrix[i - 1][j - 1] + 1, // substitution
                min<int>(
                    matrix[i][j - 1] + 1, // insertion
                    matrix[i - 1][j] + 1)); // deletion
          }
        }
      }

      return matrix[b.length][a.length];
    }

    bool guessingField(String guess, List<String> matches) {
      bool guessed = false;
      for (var match in matches) {
        String toGuess = ignoreStuff(match).toLowerCase();
        guessed = guessed ||
            (toGuess.length -
                        getTextDistance(
                            ignoreStuff(guess).toLowerCase(), toGuess)) /
                    toGuess.length >=
                GameState.guessScoreCap;
        if (guessed) return true;
      }
      return false;
    }

    double score = 0;
    tracks[state.currentTrack].fields.forEach(
      (key, value) {
        if (!value.guessed) {
          value.guessed = guessingField(guess, value.matches);
          score += value.guessed * value.score;
        }
      },
    );

    return score;
  }
}
