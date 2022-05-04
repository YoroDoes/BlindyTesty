part of 'spotify_game_bloc.dart';

class SpotifyGameState extends Equatable {
  const SpotifyGameState({
    this.playlistID,
    this.playlistLoadProgress,
    this.playlistLoadTotal,
    this.playlistLoadComplete,
    this.playlistLoadFailed,
    this.tracks,
    this.trackCount,
    this.currentTrack,
    this.rulesShown,
    this.gameOver,
    this.guessing,
    this.score,
    this.maxScore,
    this.elapsedTime,
    this.artistGuessed,
    this.songGuessed,
    this.guessScore,
  });

  const SpotifyGameState.nulls()
      : playlistID = null,
        playlistLoadProgress = null,
        playlistLoadTotal = null,
        playlistLoadComplete = null,
        playlistLoadFailed = null,
        tracks = null,
        trackCount = null,
        currentTrack = null,
        rulesShown = null,
        gameOver = null,
        guessing = null,
        score = null,
        maxScore = null,
        elapsedTime = null,
        artistGuessed = null,
        songGuessed = null,
        guessScore = null;

  // Playlist selection and loading
  final String? playlistID;
  final int? playlistLoadProgress;
  final int? playlistLoadTotal;
  final bool? playlistLoadComplete;
  final bool? playlistLoadFailed;

  // Tracks for this game
  final List<Song>? tracks;
  final int? trackCount;
  final int? currentTrack;

  // Game state
  final bool? rulesShown;
  final bool? guessing;
  final bool? gameOver;
  final double? score;
  final double? maxScore;

  //Guessing
  final int? elapsedTime;
  final bool? artistGuessed;
  final bool? songGuessed;
  final double? guessScore;

  //const stuff
  static const double artistMaxScore = .5;
  static const double songMaxScore = .5;
  static const double guessScoreCap = .75;

  @override
  List<Object?> get props => [
        playlistID,
        playlistLoadProgress,
        playlistLoadTotal,
        playlistLoadComplete,
        playlistLoadFailed,
        tracks,
        trackCount,
        currentTrack,
        rulesShown,
        guessing,
        gameOver,
        score,
        maxScore,
        elapsedTime,
        artistGuessed,
        songGuessed,
        guessScore,
      ];
}
