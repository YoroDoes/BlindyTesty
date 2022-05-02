import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kplayer/kplayer.dart';
import './app.dart';
import 'package:blindytesty/src/services/storage.dart';

void main() async {
  if (kDebugMode) print('initializing storage');
  await Storage.initStorage();
  Player.boot();

  // var player = Player.network("https://www.youtube.com/watch?v=Fp8msa5uYsc")
  //   ..play();

  // // can be awaited
  // player.streams.position
  //     .firstWhere((position) => position.inMicroseconds > 0)
  //     .then(
  //   (event) {
  //     print('STARTED');
  //     player.position = const Duration(seconds: 100);
  //     print(player.duration);
  //   },
  // );

  runApp(const App());
}
