import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:blindytesty/src/platform/bloc/platform_bloc.dart';
import 'package:blindytesty/src/services/storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platform/platform.dart';
import 'package:blindytesty/src/drawer/drawer.dart';

class SpotifyPage extends StatelessWidget {
  const SpotifyPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(builder: (_) => const SpotifyPage());
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) print('Launching Spotify Page');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spotify'),
      ),
      drawer: const MenuDrawer(page: 'spotify'),
      body: const Center(),
    );
  }
}
