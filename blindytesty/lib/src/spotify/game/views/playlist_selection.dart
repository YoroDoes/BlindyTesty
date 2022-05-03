import 'package:blindytesty/color_palettes.dart';
import 'package:blindytesty/src/spotify/auth/bloc/spotify_auth_bloc.dart';
import 'package:blindytesty/src/spotify/game/bloc/spotify_game_bloc.dart';
import 'package:blindytesty/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';

class SpotifyPlaylistSelectionView extends StatefulWidget {
  const SpotifyPlaylistSelectionView({Key? key}) : super(key: key);

  @override
  State<SpotifyPlaylistSelectionView> createState() =>
      _SpotifyPlaylistSelectionViewState();
}

class _SpotifyPlaylistSelectionViewState
    extends State<SpotifyPlaylistSelectionView> {
  String? playlistURL =
      'https://open.spotify.com/playlist/5snPvHQFjJ4vqfnc50TxOR?si=46bda0bd810b4657'; // debug default value
  final playlistURLController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    playlistURLController.text = playlistURL!; // default playlist entered
    return Center(
      child: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: playlistURLController,
              decoration: const InputDecoration(
                hintText: 'Enter a playlist URL: ',
              ),
              onChanged: (value) {
                playlistURL = value;
              },
            ),
            const Padding(padding: EdgeInsets.all(20.0)),
            SelectionButton(
              child: const Text('Use this playlist'),
              onPressed: () async {
                String? newPlaylistID = RegExp(
                        r"^(https://open\.spotify\.com/playlist/)([a-zA-Z0-9]+)(\??)")
                    .firstMatch(playlistURL ?? '')
                    ?.group(2);
                if (newPlaylistID == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invalid playlist'),
                    ),
                  );
                  return;
                }
                BlocProvider.of<SpotifyGameBloc>(context).add(
                    SpotifyGamePlaylistIDChanged(playlistID: newPlaylistID));
                // playlistID = newPlaylistID;
                // print('playlistID matched: $playlistID');
                // Playlist? playlist =
                // await SpotifyAuthBloc.spotify?.playlists.get(playlistID);
                // print(playlist?.name);
              },
              background: Palette.spotify['green'],
              foreground: Palette.spotify['blackSolid'],
            ),
          ],
        ),
      ),
    );
  }
}
