part of 'spotify_game_bloc.dart';

abstract class SpotifyGameEvent extends Equatable {
  const SpotifyGameEvent();

  @override
  List<Object> get props => [];
}

class SpotifyGamePlaylistIDChanged extends SpotifyGameEvent {
  const SpotifyGamePlaylistIDChanged({required this.playlistID});

  final String playlistID;

  @override
  List<Object> get props => [playlistID];
}

class SpotifyGamePlaylistLoadProgress extends SpotifyGameEvent {
  const SpotifyGamePlaylistLoadProgress({required this.playlistLoadProgress});

  final int playlistLoadProgress;

  @override
  List<Object> get props => [playlistLoadProgress];
}

class SpotifyGamePlaylistLoadTracks extends SpotifyGameEvent {
  const SpotifyGamePlaylistLoadTracks({required this.tracks});

  final List<Song> tracks;

  @override
  List<Object> get props => [tracks];
}

class SpotifyGamePlaylistLoadTotal extends SpotifyGameEvent {
  const SpotifyGamePlaylistLoadTotal({required this.playlistLoadTotal});

  final int playlistLoadTotal;

  @override
  List<Object> get props => [playlistLoadTotal];
}

class SpotifyGamePlaylistReset extends SpotifyGameEvent {}

class SpotifyGamePlaylistLoadDone extends SpotifyGameEvent {}

class SpotifyGamePlaylistRulesShown extends SpotifyGameEvent {}

class SpotifyGamePlaylistGuessProgress extends SpotifyGameEvent {
  const SpotifyGamePlaylistGuessProgress(
      {required this.elapsedTime, required this.totalTime});

  final int elapsedTime;
  final int totalTime;

  @override
  List<Object> get props => [elapsedTime, totalTime];
}

class SpotifyGamePlaylistGuess extends SpotifyGameEvent {
  const SpotifyGamePlaylistGuess({required this.guess});

  final String guess;

  @override
  List<Object> get props => [guess];
}

class SpotifyGamePlaylistSkipGuess extends SpotifyGameEvent {}

class SpotifyGamePlaylistNextGuess extends SpotifyGameEvent {}

class SpotifyGamePlaylistGameOver extends SpotifyGameEvent {}
