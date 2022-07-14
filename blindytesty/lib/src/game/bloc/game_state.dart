part of 'game_bloc.dart';

class GameState extends Equatable {
  const GameState({
    this.tracks = const [],
    this.trackCount = 0,
    this.fields = const {},
    this.fieldsFormat = '',
    this.rulesShown = false,
    this.gameOver = false,
    this.guessing = false,
    this.score = 0,
    this.guessScore = 0,
    this.maxScore = 0,
    this.currentTrack = 0,
    this.elapsedTime = 0,
  });

  factory GameState.fromState(
    GameState prevState, {
    List<Song>? tracks,
    int? trackCount,
    Map<String, dynamic>? fields,
    String? fieldsFormat,
    bool? rulesShown,
    bool? gameOver,
    bool? guessing,
    double? score,
    double? guessScore,
    double? maxScore,
    int? currentTrack,
    int? elapsedTime,
  }) {
    return GameState(
      tracks: tracks ?? prevState.tracks,
      trackCount: trackCount ?? prevState.trackCount,
      fields: fields ?? prevState.fields,
      fieldsFormat: fieldsFormat ?? prevState.fieldsFormat,
      rulesShown: rulesShown ?? prevState.rulesShown,
      gameOver: gameOver ?? prevState.gameOver,
      guessing: guessing ?? prevState.guessing,
      score: score ?? prevState.score,
      guessScore: guessScore ?? prevState.guessScore,
      maxScore: maxScore ?? prevState.maxScore,
      currentTrack: currentTrack ?? prevState.currentTrack,
      elapsedTime: elapsedTime ?? prevState.elapsedTime,
    );
  }

  final List<Song> tracks;
  final int trackCount;
  final Map<String, dynamic> fields;
  final String fieldsFormat;

  final bool rulesShown;
  final bool gameOver;
  final bool guessing;
  final double score;
  final double guessScore;
  final double maxScore;
  final int currentTrack;
  final int elapsedTime;

  static const double guessScoreCap = .75;

  @override
  List<Object> get props => [
        tracks,
        trackCount,
        fields,
        fieldsFormat,
        rulesShown,
        gameOver,
        guessing,
        score,
        guessScore,
        maxScore,
        currentTrack,
        elapsedTime,
      ];
}
