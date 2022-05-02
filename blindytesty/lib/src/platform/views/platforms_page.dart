import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blindytesty/src/platform/platform.dart';
import 'package:blindytesty/src/widgets/widgets.dart';
import 'package:blindytesty/color_palettes.dart';

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
            child: Text('Local files'),
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
              const Text(
                'Which music provider do you want to use ?',
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
              const Padding(padding: EdgeInsets.all(30)),
              localPlatformButton,
              const Padding(padding: EdgeInsets.all(12)),
              SelectionButton(
                onPressed: () {
                  context
                      .read<PlatformBloc>()
                      .add(const PlatformChanged('spotify'));
                },
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Image.asset(
                    "assets/spotify/Spotify_Logo_RGB_Black.png",
                    isAntiAlias: true,
                    width: 150.0,
                  ),
                ]),
                background: Palette.spotify['green'],
                foreground: Palette.spotify['blackSolid'],
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
