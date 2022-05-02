part of 'spotify_game_bloc.dart';

class SpotifyGameState extends Equatable {
  const SpotifyGameState({
    this.playlistID,
    this.playlistLoadProgress,
    this.playlistLoadTotal,
    this.playlistLoadComplete,
    this.playlistLoadFailed,
    this.tracks,
    this.rulesShown,
    this.gameOver,
    this.guessing,
    this.score,
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
        rulesShown = null,
        gameOver = null,
        guessing = null,
        score = null,
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

  // Game state
  final bool? rulesShown;
  final bool? guessing;
  final bool? gameOver;
  final double? score;

  //Guessing
  final int? elapsedTime;
  final bool? artistGuessed;
  final bool? songGuessed;
  final double? guessScore;

  @override
  List<Object?> get props => [
        playlistID,
        playlistLoadProgress,
        playlistLoadTotal,
        playlistLoadComplete,
        playlistLoadFailed,
        tracks,
        rulesShown,
        guessing,
        gameOver,
        score,
        elapsedTime,
        artistGuessed,
        songGuessed,
        guessScore,
      ];
}
