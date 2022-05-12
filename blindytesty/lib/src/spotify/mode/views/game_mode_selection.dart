import 'package:blindytesty/color_palettes.dart';
import 'package:flutter/material.dart';
import 'package:blindytesty/src/widgets/widgets.dart';
import 'package:blindytesty/src/spotify/game/views/views.dart';

class SpotifyGameModeSelectionView extends StatelessWidget {
  const SpotifyGameModeSelectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Select a game mode',
            textScaleFactor: 3,
          ),
          const Padding(padding: EdgeInsets.all(20.0)),
          SelectionButton(
            child: const Text('Playlist'),
            onPressed: () {
              Navigator.of(context).push(SpotifyPlaylistGameModePage.route());
            },
            background: Palette.spotify['green'],
            foreground: Palette.spotify['blackSolid'],
          ),
          const Padding(padding: EdgeInsets.all(20.0)),
          SelectionButton(
            child: const Text('Liked songs'),
            onPressed: () {
              Navigator.of(context).push(SpotifyLikedGameModePage.route());
            },
            background: Palette.spotify['green'],
            foreground: Palette.spotify['blackSolid'],
          ),
        ],
      ),
    );
  }
}
