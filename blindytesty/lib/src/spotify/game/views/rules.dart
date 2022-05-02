import 'package:blindytesty/src/spotify/game/bloc/spotify_game_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RulesView extends StatelessWidget {
  const RulesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Here are the rules'),
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<SpotifyGameBloc>(context)
                  .add(SpotifyGamePlaylistRulesShown());
            },
            child: const Text('Proceed'),
          )
        ],
      ),
    );
  }
}
