import 'package:blindytesty/src/game/bloc/game_bloc.dart';
import 'package:blindytesty/src/platform/platform.dart';
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
          Text(
            (GameBloc.rules[
                    BlocProvider.of<PlatformBloc>(context).state.platform]) ??
                'No rules for this platform',
          ),
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<GameBloc>(context).add(const GameRulesShown());
            },
            child: const Text('Proceed'),
          )
        ],
      ),
    );
  }
}
