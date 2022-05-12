import 'package:spotify/spotify.dart';
import 'package:kplayer/kplayer.dart' as kplayer;
import 'package:flutter/material.dart' as mat show Image;
import 'package:unofficial_jisho_api/api.dart' as jisho;
import 'package:kana_kit/kana_kit.dart';

class Song {
  Song({required this.track});

  final Track track;
  mat.Image? _cover;
  bool playing = false;
  kplayer.PlayerController? controller;
  List<String>? alternateArtists = [];
  List<String>? alternateSongs = [];
  // static const kanaKit = KanaKit();
  static bool jishoAvailable = true;
  static const kanaKit = KanaKit(
    config: KanaKitConfig(
      passKanji: true,
      passRomaji: true,
      upcaseKatakana: false,
    ),
  );
  bool generatingAlternatives = false;
  static bool stopGeneratingAlternatives = false;

  kplayer.PlayerStreams get streams => controller!.streams;
  int get duration => (controller != null &&
          (controller!.duration.inMicroseconds != 0 && controller!.playing))
      ? controller!.duration.inMilliseconds
      : 30000;

  String get name => track.name ?? '';
  List<String> get namesToGuess => (generatingAlternatives
      ? [track.name ?? '']
      : [track.name ?? '', ...?alternateSongs]);
  List<String> get artists =>
      track.artists?.map((e) => e.name ?? '').toList() ?? [''];
  List<String> get artistsToGuess => (generatingAlternatives
      ? (track.artists?.map((e) => e.name ?? '').toList() ?? [''])
      : [
          ...(track.artists?.map((e) => e.name ?? '').toList() ?? ['']),
          ...?alternateArtists
        ]);
  mat.Image? get cover {
    _cover ??= mat.Image.network(
      track.album?.images?.first.url ?? '',
      height: 300.0,
    );
    return _cover;
  }

  Future<void> play() async {
    kplayer.PlayerController.enableLog = false;
    print('Now playing ${track.name} by ${track.artists?.map(
          (e) => e.name,
        ).join(",")} from ${track.previewUrl}');

    kplayer.PlayerController.palyers.forEach((player) {
      player.stop();
    });
    controller = kplayer.Player.network(
      track.previewUrl ?? '',
    );
    controller?.play();
    playing = true;
  }

  Future<String> romajiReading(japaneseText) async {
    //TODO cleanup japaneseText beforehand
    String reading = '';
    if (Song.jishoAvailable) {
      int failsafe = 100;
      String toReduce = japaneseText;
      while (toReduce.isNotEmpty && failsafe-- > 0) {
        String char = toReduce.substring(0, 1);
        String charHex =
            toReduce.codeUnitAt(0).toRadixString(16).padLeft(4, '0');
        if (charHex.compareTo('4e00') >= 0 && charHex.compareTo('9faf') <= 0) {
          // Kanji
          await jisho.searchForPhrase(toReduce).then((result) async {
            if (result.data != null) {
              var allMatch = result.data?.where((element) =>
                  element.japanese.first.word != null &&
                  toReduce.startsWith(element.japanese.first.word!));
              if (allMatch?.isNotEmpty ?? false) {
                var match = allMatch?.reduce((value, element) =>
                    (value.japanese.first.word?.length ?? 0) >=
                            (element.japanese.first.word?.length ?? 0)
                        ? value
                        : element);
                reading += match?.japanese.first.reading ?? '';
                toReduce = toReduce.replaceRange(
                    0, (match?.japanese.first.word?.length ?? 0), '');
              } else {
                //try to just get the first available kunyomi and call it a day
                await jisho.searchForKanji(char).then((result) {
                  var yomi = '';
                  if (result.data != null) {
                    yomi = (result.data?.kunyomi.first ??
                            result.data?.onyomi.first ??
                            '')
                        .replaceAll(RegExp(r'([.].*|[-])'), '');
                  }
                  reading += yomi;
                  toReduce = toReduce.replaceRange(0, 1, '');
                }).catchError((e) {
                  reading = kanaKit.toKana(japaneseText);
                  toReduce = '';
                  print('Kanji search error: $e');
                });
              }
            }
          }).catchError((e) {
            reading = kanaKit.toHiragana(japaneseText);
            toReduce = '';
            print('Phrase search error: $e');
          });
        } else {
          reading += char;
          toReduce = toReduce.replaceRange(0, 1, '');
        }
      }
    } else {
      reading = kanaKit.toHiragana(
          japaneseText); // lame ass version if jisho is not available
    }
    // Romajify
    return kanaKit.toRomaji(reading);
  }

  Future<void> generateJapaneseReadings() async {
    generatingAlternatives = true;
    alternateArtists?.addAll(await Future.wait(
      artists.where((artist) {
        String reduced = artist.replaceAll(RegExp(r'\([^\)]*\)'), '');
        if (kanaKit.isMixed(reduced) || kanaKit.isJapanese(reduced)) {
          return true;
        }
        print('Ignoring japanese generation for artist $artist');
        return false;
      }).map((artist) {
        return romajiReading(artist)
          ..then((value) => print('generated $artist as $value'));
      }),
    ));
    if (kanaKit.isMixed(track.name ?? '') ||
        kanaKit.isJapanese(track.name ?? '')) {
      alternateSongs?.add(await romajiReading(track.name).then((value) {
        print('generated ${track.name} as $value');
        return value;
      }));
    } else {
      print('Ignoring japanese generation for title ${track.name}');
    }
    generatingAlternatives = false;
  }

  static Future<void> generateJapanese(List<Song> songs) async {
    stopGeneratingAlternatives = false;
    await jisho.searchForKanji('日').catchError((e) {
      Song.jishoAvailable = false;
    });
    List<Song> tmpSongs = List.from(songs);
    for (Song song in tmpSongs) {
      await song.generateJapaneseReadings();
      await Future.delayed(const Duration(milliseconds: 500));
      if (stopGeneratingAlternatives) {
        stopGeneratingAlternatives = false;
        return;
      }
    }
  }
}
