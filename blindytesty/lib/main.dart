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
  // var player = Player.network(
  //     "https://p.scdn.co/mp3-preview/1e0f26db1499131a480cf695dd1909160781ac19?cid=0c9ef2bc7b2a4189b06ed071c7dd0dfd")
  //   ..play()
  //   ..volume = 0.1;

  // Future.delayed(Duration(seconds: 5), () => print(player.duration.inSeconds));

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

  // runApp(MaterialApp(
  //   home: Scaffold(body: PlayerBar(player: player)),
  // ));
  runApp(const App());
}
