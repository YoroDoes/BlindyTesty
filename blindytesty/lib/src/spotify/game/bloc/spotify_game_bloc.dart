import 'package:blindytesty/src/spotify/game/models/models.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'spotify_game_event.dart';
part 'spotify_game_state.dart';

class SpotifyGameBloc extends Bloc<SpotifyGameEvent, SpotifyGameState> {
  SpotifyGameBloc() : super(const SpotifyGameState()) {
    on<SpotifyGamePlaylistIDChanged>(_onSpotifyGamePlaylistIDChanged);
    on<SpotifyGamePlaylistLoadProgress>(_onSpotifyGamePlaylistLoadProgress);
    on<SpotifyGamePlaylistLoadTracks>(_onSpotifyGamePlaylistLoadTracks);
    on<SpotifyGamePlaylistLoadTotal>(_onSpotifyGamePlaylistLoadTotal);
    on<SpotifyGamePlaylistReset>(_onSpotifyGamePlaylistReset);
    on<SpotifyGamePlaylistLoadDone>(_onSpotifyGamePlaylistLoadDone);
    on<SpotifyGamePlaylistRulesShown>(_onSpotifyGamePlaylistRulesShown);
    on<SpotifyGamePlaylistGuessProgress>(_onSpotifyGamePlaylistGuessProgress);
    on<SpotifyGamePlaylistGuess>(_onSpotifyGamePlaylistGuess);
    on<SpotifyGamePlaylistNextGuess>(_onSpotifyGamePlaylistNextGuess);
  }

  void _onSpotifyGamePlaylistIDChanged(
    SpotifyGamePlaylistIDChanged event,
    Emitter<SpotifyGameState> emit,
  ) {
    emit(copyMissing(playlistID: event.playlistID));
  }

  void _onSpotifyGamePlaylistLoadProgress(
    SpotifyGamePlaylistLoadProgress event,
    Emitter<SpotifyGameState> emit,
  ) {
    emit(copyMissing(playlistLoadProgress: event.playlistLoadProgress));
  }

  void _onSpotifyGamePlaylistLoadTracks(
    SpotifyGamePlaylistLoadTracks event,
    Emitter<SpotifyGameState> emit,
  ) {
    int? playlistLoadProgress;

    playlistLoadProgress =
        (state.playlistLoadProgress ?? 0) + event.tracks.length;
    if (state.playlistLoadTotal != null &&
        playlistLoadProgress > state.playlistLoadTotal!) {
      playlistLoadProgress = state.playlistLoadTotal;
    }
    emit(copyMissing(
        tracks: [...?state.tracks, ...event.tracks],
        playlistLoadProgress: playlistLoadProgress));
  }

  void _onSpotifyGamePlaylistLoadTotal(
    SpotifyGamePlaylistLoadTotal event,
    Emitter<SpotifyGameState> emit,
  ) {
    emit(copyMissing(playlistLoadTotal: event.playlistLoadTotal));
  }

  void _onSpotifyGamePlaylistReset(
    SpotifyGamePlaylistReset event,
    Emitter<SpotifyGameState> emit,
  ) {
    emit(const SpotifyGameState.nulls());
  }

  void _onSpotifyGamePlaylistLoadDone(
    SpotifyGamePlaylistLoadDone event,
    Emitter<SpotifyGameState> emit,
  ) {
    bool complete = true;
    bool? failed;
    if (state.tracks == null || state.tracks!.isEmpty) {
      complete = false;
      failed = true;
    } else {
      state.tracks!.shuffle();
    }

    emit(copyMissing(
      playlistLoadTotal: null,
      playlistLoadComplete: complete,
      playlistLoadFailed: failed,
      playlistLoadProgress: 0,
    ));
  }

  void _onSpotifyGamePlaylistRulesShown(
    SpotifyGamePlaylistRulesShown event,
    Emitter<SpotifyGameState> emit,
  ) {
    emit(copyMissing(
      rulesShown: true,
      guessing: true,
      gameOver: false,
    ));
  }

  void _onSpotifyGamePlaylistGuessProgress(
    SpotifyGamePlaylistGuessProgress event,
    Emitter<SpotifyGameState> emit,
  ) {
    bool guessing = true;
    if (event.elapsedTime >= event.totalTime) guessing = false;

    emit(copyMissing(
      elapsedTime: event.elapsedTime,
      guessing: guessing,
    ));
  }

  void _onSpotifyGamePlaylistGuess(
    SpotifyGamePlaylistGuess event,
    Emitter<SpotifyGameState> emit,
  ) {
    Set<bool> guessed;
    guessed = _guess(event.guess);
    bool artistGuessed = (state.artistGuessed ?? false) || guessed.first;
    bool songGuessed = (state.songGuessed ?? false) || guessed.last;

    emit(copyMissing(
      artistGuessed: artistGuessed,
      songGuessed: songGuessed,
      guessing: !(artistGuessed && songGuessed),
    ));
  }

  void _onSpotifyGamePlaylistNextGuess(
    SpotifyGamePlaylistNextGuess event,
    Emitter<SpotifyGameState> emit,
  ) {
    double score = (state.score ?? 0) + (state.guessScore ?? 0);
    state.tracks?.removeAt(0);
    emit(copyMissing(
      score: score,
      guessScore: 0,
      elapsedTime: 0,
      artistGuessed: false,
      songGuessed: false,
      guessing: true,
      gameOver: state.tracks?.isEmpty,
    ));
  }

  SpotifyGameState copyMissing({
    String? playlistID,
    int? playlistLoadProgress,
    int? playlistLoadTotal,
    bool? playlistLoadComplete,
    bool? playlistLoadFailed,
    List<Song>? tracks,
    bool? rulesShown,
    bool? guessing,
    bool? gameOver,
    double? score,
    int? elapsedTime,
    bool? artistGuessed,
    bool? songGuessed,
    double? guessScore,
  }) =>
      SpotifyGameState(
        playlistID: playlistID ?? state.playlistID,
        playlistLoadProgress:
            playlistLoadProgress ?? state.playlistLoadProgress,
        playlistLoadTotal: playlistLoadTotal ?? state.playlistLoadTotal,
        playlistLoadComplete:
            playlistLoadComplete ?? state.playlistLoadComplete,
        playlistLoadFailed: playlistLoadFailed ?? state.playlistLoadFailed,
        tracks: tracks ?? state.tracks,
        rulesShown: rulesShown ?? state.rulesShown,
        guessing: guessing ?? state.guessing,
        gameOver: gameOver ?? state.gameOver,
        score: score ?? state.score,
        elapsedTime: elapsedTime ?? state.elapsedTime,
        artistGuessed: artistGuessed ?? state.artistGuessed,
        songGuessed: songGuessed ?? state.songGuessed,
        guessScore: guessScore ?? state.guessScore,
      );

  Set<bool> _guess(String guess) {
    bool artistGuessed = false;
    bool songGuessed = false;

    //TODO better guess logic

    songGuessed =
        guess.toLowerCase().contains(state.tracks!.first.name.toLowerCase());
    artistGuessed = guess
        .toLowerCase()
        .contains(state.tracks!.first.artistToGuess.toLowerCase());

    return {artistGuessed, songGuessed};
  }
}
