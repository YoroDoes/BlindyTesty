import 'dart:math';

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
    on<SpotifyGamePlaylistSkipGuess>(_onSpotifyGamePlaylistSkipGuess);
    on<SpotifyGamePlaylistNextGuess>(_onSpotifyGamePlaylistNextGuess);
    on<SpotifyGamePlaylistGameOver>(_onSpotifyGamePlaylistGameOver);
  }

  @override
  Future<void> close() {
    Song.stopGeneratingAlternatives = true;
    return super.close();
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
    Song.stopGeneratingAlternatives = true;
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
      state.tracks?.shuffle();
      Song.generateJapanese(state.tracks ?? []);
    }

    emit(copyMissing(
      playlistLoadTotal: null,
      playlistLoadComplete: complete,
      playlistLoadFailed: failed,
      playlistLoadProgress: 0,
      trackCount: state.tracks!.length,
      currentTrack: 1,
      maxScore: (state.tracks!.length.toDouble() *
          (SpotifyGameState.artistMaxScore + SpotifyGameState.songMaxScore)),
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
    bool guessing = state.guessing ?? true;
    if (event.elapsedTime >= event.totalTime || !event.playing) {
      guessing = false;
    }

    // print(
    // '${event.elapsedTime}, ${event.totalTime} $guessing ${event.playing}');

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
    double score = 0;
    guessed = _guess(event.guess);
    bool artistGuessed = (state.artistGuessed ?? false) || guessed.first;
    bool songGuessed = (state.songGuessed ?? false) || guessed.last;

    if (!(state.songGuessed ?? false) && guessed.last) {
      score += SpotifyGameState.songMaxScore;
    }
    if (!(state.artistGuessed ?? false) && guessed.first) {
      score += SpotifyGameState.artistMaxScore;
    }

    emit(copyMissing(
      artistGuessed: artistGuessed,
      songGuessed: songGuessed,
      guessing: !(artistGuessed && songGuessed),
      guessScore: (state.guessScore ?? 0) + score,
    ));
  }

  void _onSpotifyGamePlaylistSkipGuess(
    SpotifyGamePlaylistSkipGuess event,
    Emitter<SpotifyGameState> emit,
  ) {
    emit(copyMissing(
      guessing: false,
    ));
  }

  void _onSpotifyGamePlaylistNextGuess(
    SpotifyGamePlaylistNextGuess event,
    Emitter<SpotifyGameState> emit,
  ) {
    print('Next Guess');
    double score = (state.score ?? 0) + (state.guessScore ?? 0);
    state.tracks?.removeAt(0);
    emit(copyMissing(
      score: score,
      guessScore: 0,
      elapsedTime: 0,
      artistGuessed: false,
      songGuessed: false,
      guessing: true,
      currentTrack: (state.currentTrack ?? 1) + 1,
      gameOver: state.tracks?.isEmpty,
    ));
  }

  void _onSpotifyGamePlaylistGameOver(
    SpotifyGamePlaylistGameOver event,
    Emitter<SpotifyGameState> emit,
  ) {
    print('Game Over');
    double score = (state.score ?? 0) + (state.guessScore ?? 0);
    state.tracks?.removeAt(0);
    emit(copyMissing(
      score: score,
      gameOver: true,
    ));
  }

  SpotifyGameState copyMissing({
    String? playlistID,
    int? playlistLoadProgress,
    int? playlistLoadTotal,
    bool? playlistLoadComplete,
    bool? playlistLoadFailed,
    List<Song>? tracks,
    int? trackCount,
    int? currentTrack,
    bool? rulesShown,
    bool? guessing,
    bool? gameOver,
    double? score,
    double? maxScore,
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
        trackCount: trackCount ?? state.trackCount,
        currentTrack: currentTrack ?? state.currentTrack,
        rulesShown: rulesShown ?? state.rulesShown,
        guessing: guessing ?? state.guessing,
        gameOver: gameOver ?? state.gameOver,
        score: score ?? state.score,
        maxScore: maxScore ?? state.maxScore,
        elapsedTime: elapsedTime ?? state.elapsedTime,
        artistGuessed: artistGuessed ?? state.artistGuessed,
        songGuessed: songGuessed ?? state.songGuessed,
        guessScore: guessScore ?? state.guessScore,
      );

  Set<bool> _guess(String guess) {
    bool artistGuessed = false;
    bool songGuessed = false;

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

    bool guessingArtist(String guess) {
      bool guessed = false;
      for (var artist in state.tracks!.first.artistsToGuess) {
        String toGuess = ignoreStuff(artist).toLowerCase();
        guessed = guessed ||
            (toGuess.length -
                        getTextDistance(
                            ignoreStuff(guess).toLowerCase(), toGuess)) /
                    toGuess.length >=
                SpotifyGameState.guessScoreCap;
        if (guessed) return true;
      }
      return false;
    }

    bool guessingSong(String guess) {
      bool guessed = false;
      for (var songName in state.tracks!.first.namesToGuess) {
        String toGuess = ignoreStuff(songName).toLowerCase();
        guessed = guessed ||
            (toGuess.length -
                        getTextDistance(
                            ignoreStuff(guess).toLowerCase(), toGuess)) /
                    toGuess.length >=
                SpotifyGameState.guessScoreCap;
        if (guessed) return true;
      }
      return false;
    }

    artistGuessed = (state.artistGuessed ?? false) || guessingArtist(guess);
    songGuessed = (state.songGuessed ?? false) || guessingSong(guess);

    return {artistGuessed, songGuessed};
  }
}
