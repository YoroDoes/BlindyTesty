import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:blindytesty/src/platform/platform.dart';
import 'package:blindytesty/src/services/models/models.dart';
import 'package:blindytesty/src/spotify/auth/views/spotify_auth_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blindytesty/src/splash/splash.dart';
import 'package:blindytesty/src/services/storage.dart';

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    SettingsObject settings = Storage.getSettings();
    context
        .read<PlatformBloc>()
        .add(PlatformChanged(settings.selectedPlatform ?? 'unknown'));
    return MaterialApp(
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<PlatformBloc, PlatformState>(
          listener: (context, state) {
            if (kDebugMode) {
              print(
                  'rebuilding platform page, PlatformState: ${state.platform}');
            }
            switch (state.platform) {
              case 'local':
                //@TODO
                break;
              case 'spotify':
                _navigator.pushAndRemoveUntil<void>(
                    SpotifyAuthPage.route(), (route) => false);
                break;
              case 'youtube':
                //@TODO
                break;
              default:
                _navigator.pushAndRemoveUntil<void>(
                    PlatformSelectionPage.route(), (route) => false);
                break;
            }
          },
          child: child,
        );
      },
      home: const SplashPage(),
    );
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) print('Launching App');
    return BlocProvider(
      create: (_) => PlatformBloc(),
      child: const AppView(),
    );
  }
}
