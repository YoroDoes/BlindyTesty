import 'package:flutter/foundation.dart';
import 'package:kplayer/kplayer.dart' as kplayer;
import 'package:unofficial_jisho_api/api.dart' as jisho;
import 'package:kana_kit/kana_kit.dart';
import 'package:flutter/material.dart' as mat;

abstract class Song {
  bool ready = false;
  void Function()? onReadyCallback;
  kplayer.PlayerController? controller;
  Map<String, dynamic> fields = {};
  // fields = {
  //          'artistField':
  //          {
  //            'matches': ['firstVariant', 'secondVariant',], //All guess matches
  //            'guessed': true, //Has this field been guessed
  //            'score': .5, //The score given for guessing this field
  //          },
  //         }
  Duration guessDuration = const Duration(milliseconds: 30000);

  static bool jishoAvailable = true;
  static const kanaKit = KanaKit(
    config: KanaKitConfig(
      passKanji: true,
      passRomaji: true,
      upcaseKatakana: false,
    ),
  );
  bool generatingAlternatives = false;
  static bool _stopGeneratingAlternatives = false;

  kplayer.PlayerStreams? get streams => controller?.streams;

  void onReady(void Function() callback) {
    onReadyCallback = callback;
  }

  Duration get duration =>
      ready ? (controller?.duration ?? guessDuration) : guessDuration;

  List<String> fieldMatches(String field) => fields[field]?['matches'] ?? [];
  void generateFields(); //TO IMPLEMENT
  String get fullTitle; //TO IMPLEMENT
  Future<void> play(); //TO IMPLEMENT
  bool get isPlaying; //TO IMPLEMENT
  mat.Image? get cover; //TO IMPLEMENT

  //***************** Japanese text generation
  Future<String> romajiReading(japaneseText) async {
    japaneseText = japaneseText.replaceAll(RegExp(r'。、・'), '');
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
                  if (kDebugMode) {
                    print('Kanji search error: $e');
                  }
                });
              }
            }
          }).catchError((e) {
            reading = kanaKit.toHiragana(japaneseText);
            toReduce = '';
            if (kDebugMode) {
              print('Phrase search error: $e');
            }
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

    for (var field in fields.values) {
      field['matches'].addAll(await Future.wait(
        field['matches'].where((text) {
          String reduced = text.replaceAll(RegExp(r'\([^\)]*\)'), '');
          if (kanaKit.isMixed(reduced) || kanaKit.isJapanese(reduced)) {
            return true;
          }
          if (kDebugMode) {
            print('Ignoring japanese generation for field $text');
          }
          return false;
        }).map((text) {
          return romajiReading(text)
            ..then((value) {
              if (kDebugMode) print('generated $text as $value');
            });
        }),
      ));
    }
    generatingAlternatives = false;
  }

  static void cancelAlternativeGeneration() {
    _stopGeneratingAlternatives = true;
  }

  static Future<void> generateJapanese(List<Song> songs) async {
    _stopGeneratingAlternatives = false;
    await jisho.searchForKanji('日').catchError((e) {
      Song.jishoAvailable = false;
    });
    List<Song> tmpSongs = List.from(songs);
    for (Song song in tmpSongs) {
      await song.generateJapaneseReadings();
      await Future.delayed(const Duration(milliseconds: 500));
      if (_stopGeneratingAlternatives) {
        _stopGeneratingAlternatives = false;
        return;
      }
    }
  }
}
