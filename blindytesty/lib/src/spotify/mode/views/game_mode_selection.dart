import 'package:flutter/material.dart';
import 'package:blindytesty/src/widgets/widgets.dart';
import 'package:blindytesty/src/spotify/game/views/views.dart';

class SpotifyGameModeSelectionView extends StatelessWidget {
  const SpotifyGameModeSelectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BouncyScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Select a game mode',
            textScaleFactor: 3,
            textAlign: TextAlign.center,
          ),
          const Padding(padding: EdgeInsets.all(20.0)),
          SelectionButton(
            onPressed: () {
              Navigator.of(context).push(SpotifyPlaylistGameModePage.route());
            },
            child: const Text('Playlist'),
          ),
          const Padding(padding: EdgeInsets.all(20.0)),
          SelectionButton(
            onPressed: () {
              Navigator.of(context).push(SpotifyLikedGameModePage.route());
            },
            child: const Text(
              'Liked songs',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
