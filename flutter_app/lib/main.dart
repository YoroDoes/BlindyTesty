import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kplayer/kplayer.dart';
import './app.dart';
import 'package:flutter_app/src/services/storage.dart';

void main() async {
  Player.boot();
  if (kDebugMode) print('initializing storage');
  await Storage.initStorage();
  // await Hive.openBox<String>('platform');
  // Future<void>(() => Player.network(
  //         "https://p.scdn.co/mp3-preview/beb71b347ec0ec922780288793a6165a83a90f33?cid=0c9ef2bc7b2a4189b06ed071c7dd0dfd")
  //     .play());
  runApp(const App());
}
