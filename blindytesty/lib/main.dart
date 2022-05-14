import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kplayer/kplayer.dart';
import 'package:overlay_support/overlay_support.dart';
import './app.dart';
import 'package:blindytesty/src/services/storage.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:file_picker/file_picker.dart';

void main() async {
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  if (kDebugMode) print('initializing storage');
  await Storage.initStorage();
  Player.boot();

  //*********************** YOUTUBE EXAMPLES */

  // var player = Player.network("https://www.youtube.com/watch?v=sgdPlDG1-8k")
  //   ..play()
  //   ..volume = 0.5;

  // player.streams.status
  // .firstWhere((element) => element == PlayerStatus.playing)
  // .then((_) => player.pause());
  // player.streams.position
  //     .take(1)
  //     .first
  //     .then((_) => player.position = const Duration(seconds: 129));
  // Future.delayed(const Duration(seconds: 10), () => player.stop());

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

  //*********************** LOCAL FILES EXAMPLE */

  // FilePicker.platform.getDirectoryPath().then((dir) {
  //   if (dir == null) return;
  //   var player = Player.file('$dir/the_turdis.mp4')
  //     ..play()
  //     ..volume = 0.5;
  // });

  //*********************** YOUTUBE PLAYLISTS DATABASE EXAMPLE */

  // Yeah that's a bit weird but it's just a key for a bot without priviledges
//   var key = """-----BEGIN RSA PRIVATE KEY-----
// MIIEpAIBAAKCAQEA2hunCsV78BCYjqoW9W2Bm2VzXu+rrNJr+5tBVKU5jyhPzx6G
// J3rLIpoZwwlYhRA1behwGFBv8wxMX56KSyKh1Xw1KXSX3OzoSXmzY1gfGV4cpBCX
// ifmSEiZlhcztDTt4FshjdNO7BjtDinOlkhVbaQKi9DUSfcEfbuTsmF87BKGNVCHI
// v66WVf26c7pHQG2oLNfCFK0IsfVAPUNoEiJFl7wofzlQnQNLVrcHWHNEgqUWlBk/
// Ww+iJfLVDtbOP9pzf/H2bbJ932d6v5R/VMckgjNuTpMz9EF/x+h+Gncoi6LFh5um
// ohlpNCGjAOTALXvD1DPugEhIh9IBZEP8O3AS2QIDAQABAoIBAQCq3RDeWlk+dvHc
// iZkUyaXIJBDepal66RlY8YablhhicvUaz9HO6d5rDAf0h8TF8S26HWZ7VcBtygum
// uN+j/syDHxvSjxlNJHbQ4LtMr0Mlr1mGmcztdQselt/fkut9+0GXr4JiimAwgIrn
// 0rM5nuuOd1dLMqx6wakrScGjmK72b1qlHGLP7MRAZQHGWVSf5XgUMvzzu8s6IN87
// +nWQrZrH6RJpstU8RX9q1Og4zwwofpsT9f3TIk5ywruwkla/hnCbUc1SQvKxVUDK
// EvZG86DkeLW7Y8j2lPvKXHjYrM3vQ+28PbfvGGnoXC0LpCbWdnSTWh71FTxQwi0i
// /lzmus6VAoGBAPFjA5/9Nvdxsht3WIf/CVbUBs0v9OvwFI/tFlfhBIO1xJ0DPcIs
// Bo5xcG4dGQYF8BeIxMycYQDJpdovWt1GG3IN5gEHlAITholcW6412gYi9pRxGp6/
// 6fx8VzruFDDm2bFT6jjCbQK8yGRT52uOLihA6Kf1svGIYmRO5cxKqzNDAoGBAOdP
// 3eGxnF0VC3tY5Dud6BhQztYxwh/9I5UrLzbwgNonPKhs/iExExkM2F3qp0WqJy3Q
// CGdZwSLtq2H7hZQDI6msZNxNfZT4fbh2dIkhJo0fHH04Qifsb2Uub7QqnkLSQYRp
// fNfXw3OmqbODz95M0Fj0bZWjMxkwI7AvXSQDTKmzAoGBANTQ6v0/DhsSzmiQzCj6
// nY1D2ctFoLXzMO3DpZNM++Hze6jClsx+bDlhojIyzUEWMxtMpdWPeaZsIiE+5ul3
// SfNAdawqtj8uX8ry9pGdQN9wK92r6kBUC0NjjLST+pEytnM0/KeWIu3q6vIpVzro
// W6F5uKV8ZYu1JqoxNUDsBAxpAoGAV/Y9MEh0Z8lK9nsVP76KtkR0g2ukoLmIwH8N
// k1zeAxeMr5fTBBg/ZPVHil9jgNB12awUpgixs3CiDb6yS1juROWz7TrimLXuSSly
// o3shx+Se1teAAOKeceG4xNC4Ij0GgS4ENahtQRuNySBE+gpH6Kv6yD6pfdiambNJ
// PhqrGpUCgYB9T6BeWY4xyh0CFvO95fiCezx+L3SQIHGEsP/GIlJHbbwjkUAYsLhn
// 8MauSB1iz/1lO3dUAhRqw780pB1uSs8dPCLN1UXZ4WQUNjgvVawNVMFjRolIy7H3
// 2NHv9C2V8hhLc7l1Z/XVlAA/y3/edv3FQkf8eZXTbKihvwLrOlA0kA==
// -----END RSA PRIVATE KEY-----""";
//   const String appId = '200246';
//   const String installationId = '25646847';
//   const String playlistsRepo = 'YoroDoes/BlindyTesty-playlists';
//   var jwt = JWT({
//     "iat": (DateTime.now()
//                 .subtract(
//                   const Duration(minutes: 1),
//                 )
//                 .millisecondsSinceEpoch /
//             1000)
//         .floor(),
//     "exp": (DateTime.now()
//                 .add(
//                   const Duration(minutes: 10),
//                 )
//                 .millisecondsSinceEpoch /
//             1000)
//         .floor(),
//     "iss": appId
//   }).sign(RSAPrivateKey(key), algorithm: JWTAlgorithm.RS256);
//   String accessToken = '';
//   await Dio()
//       .post(
//         'https://api.github.com/app/installations/$installationId/access_tokens',
//         options: Options(
//           headers: {
//             "Accept": "application/vnd.github.v3+json",
//             "Authorization": "Bearer $jwt",
//           },
//         ),
//       )
//       .then((result) => accessToken = result.data['token']);
//   print(accessToken);
//   print(jwt);
//   Dio().post('https://api.github.com/repos/$playlistsRepo/issues',
//       options: Options(
//         headers: {
//           "Accept": "application/vnd.github.v3+json",
//           "Authorization": "Bearer $accessToken",
//         },
//       ),
//       data: {
//         "title": "Test",
//         "body": "testing api",
//         "labels": ["playlist"],
//       });

  runApp(const OverlaySupport.global(child: App()));
}
