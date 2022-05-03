import 'package:spotify/spotify.dart';
import 'package:kplayer/kplayer.dart' as kplayer;
import 'package:flutter/material.dart' as mat show Image;

class Song {
  Song({required this.track});

  final Track track;
  mat.Image? _cover;
  bool playing = false;
  kplayer.PlayerController? controller;

  Future<void> play() async {
    kplayer.PlayerController.enableLog = false;
    print('Now playing ${track.name} by ${track.artists?.map(
          (e) => e.name,
        ).join(",")} from ${track.previewUrl}');

    kplayer.PlayerController.palyers.forEach((player) {
      player.stop();
    });
    controller = kplayer.Player.network(
      track.previewUrl!,
    );
    controller?.play();
    playing = true;
  }

  kplayer.PlayerStreams get streams => controller!.streams;
  int get duration => (controller != null &&
          (controller!.duration.inMicroseconds != 0 && controller!.playing))
      ? controller!.duration.inMilliseconds
      : 30000;

  String get name => track.name!;
  List<String> get artists => track.artists!.map((e) => e.name!).toList();
  String get artistToGuess => track.artists!.map((e) => e.name!).first;
  mat.Image? get cover {
    _cover ??= mat.Image.network(
      track.album!.images!.first.url!,
      height: 300.0,
    );
    return _cover;
  }
}
