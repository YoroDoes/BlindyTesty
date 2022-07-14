part of 'game_bloc.dart';

abstract class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

class GameRulesShown extends GameEvent {
  const GameRulesShown();
}

class GameGuessProgress extends GameEvent {
  const GameGuessProgress({
    required this.elapsedTime,
    required this.totalTime,
    required this.playing,
  });

  final int elapsedTime;
  final int totalTime;
  final bool playing;

  @override
  List<Object> get props => [
        elapsedTime,
        totalTime,
        playing,
      ];
}

class GameGuess extends GameEvent {
  const GameGuess({
    required this.guess,
  });

  final String guess;

  @override
  List<Object> get props => [
        guess,
      ];
}

class GameSkipGuess extends GameEvent {
  const GameSkipGuess();
}

class GameOver extends GameEvent {
  const GameOver();
}

class GameNextGuess extends GameEvent {
  const GameNextGuess();
}
