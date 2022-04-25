import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:blindytesty/src/spotify/views/spotify_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blindytesty/src/platform/platform.dart';
import 'package:blindytesty/src/services/storage.dart';
import 'package:blindytesty/src/spotify/bloc/spotify_bloc.dart';
import 'package:blindytesty/src/widgets/widgets.dart';

class PlatformSelectionPage extends StatelessWidget {
  const PlatformSelectionPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
        builder: (_) => const PlatformSelectionPage());
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) print('Launching Platform Selection Page');

    // Platform dependent widgets
    Widget localPlatformButton = kIsWeb
        ? const Center(
            heightFactor: 0.0,
            widthFactor: 0.0,
          )
        : const SelectionButton(
            onPressed: null,
            child: Text('Local'),
          );

    // Main View
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              localPlatformButton,
              const Padding(padding: EdgeInsets.all(12)),
              SelectionButton(
                onPressed: () {
                  context
                      .read<PlatformBloc>()
                      .add(const PlatformChanged('spotify'));
                },
                child: Row(mainAxisSize: MainAxisSize.min, children: const [
                  Icon(Icons.library_music),
                  Padding(padding: EdgeInsets.only(right: 10)),
                  Text('Spotify'),
                ]),
                background: const Color.fromARGB(255, 39, 223, 113),
                foreground: const Color.fromARGB(180, 0, 0, 0),
              ),
              const Padding(padding: EdgeInsets.all(12)),
              const SelectionButton(
                onPressed: null,
                child: Text('youtube'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
