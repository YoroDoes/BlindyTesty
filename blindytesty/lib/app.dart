import 'package:blindytesty/color_palettes.dart';
import 'package:blindytesty/src/game/bloc/game_bloc.dart';
import 'package:blindytesty/src/local/setup/bloc/local_setup_bloc.dart';
import 'package:blindytesty/src/local/setup/views/setup_page.dart';
import 'package:blindytesty/src/services/providers/theme_provider.dart';
import 'package:blindytesty/src/spotify/auth/bloc/spotify_auth_bloc.dart';
import 'package:blindytesty/src/youtube/mode/mode.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:blindytesty/src/platform/platform.dart';
import 'package:blindytesty/src/services/models/models.dart';
import 'package:blindytesty/src/spotify/auth/views/spotify_auth_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blindytesty/src/splash/splash.dart';
import 'package:blindytesty/src/services/storage.dart';
import 'package:provider/provider.dart';

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
    print('Building App');
    SettingsObject settings = Storage.getSettings();
    Future.delayed(
      const Duration(milliseconds: 100),
      () => context
          .read<PlatformBloc>()
          .add(PlatformChanged(settings.selectedPlatform ?? 'unknown')),
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => LocalSetupBloc(),
            ),
            BlocProvider(
              create: (context) => GameBloc(),
            ),
            BlocProvider(
              create: (context) => SpotifyAuthBloc(),
            ),
            BlocProvider(
              create: (context) => PlatformBloc(),
            ),
          ],
          child: MaterialApp(
            title: "Blindy Testy",
            themeMode: themeProvider.selectedThemeMode,
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Palette.getMaterialColorFromColor(
                  themeProvider.selectedPrimaryColor),
              primaryColor: themeProvider.selectedPrimaryColor,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Palette.getMaterialColorFromColor(
                  themeProvider.selectedPrimaryColor),
              primaryColor: themeProvider.selectedPrimaryColor,
            ),
            navigatorKey: _navigatorKey,
            builder: (context, child) {
              print('MaterialApp builder');
              return BlocListener<PlatformBloc, PlatformState>(
                listenWhen: (previous, current) =>
                    previous.platform != current.platform,
                listener: (context, state) {
                  print('App BlocListener');
                  if (kDebugMode) {
                    print(
                        'rebuilding platform page, PlatformState: ${state.platform}');
                  }
                  switch (state.platform) {
                    case 'local':
                      themeProvider
                          .setSelectedPrimaryColor(Palette.normal['blue']!);
                      _navigator.pushAndRemoveUntil<void>(
                          LocalSetupPage.route(), (route) => false);
                      break;
                    case 'spotify':
                      themeProvider
                          .setSelectedPrimaryColor(Palette.spotify['green']!);
                      _navigator.pushAndRemoveUntil<void>(
                          SpotifyAuthPage.route(), (route) => false);
                      break;
                    case 'youtube':
                      themeProvider
                          .setSelectedPrimaryColor(Palette.youtube['red']!);
                      _navigator.pushAndRemoveUntil<void>(
                          YoutubeModePage.route(), (route) => false);
                      break;
                    default:
                      themeProvider
                          .setSelectedPrimaryColor(Palette.normal['blue']!);
                      _navigator.pushAndRemoveUntil<void>(
                          PlatformSelectionPage.route(), (route) => false);
                      break;
                  }
                },
                child: child,
              );
            },
            home: const SplashPage(),
          ),
        );
      }),
    );
  }
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) print('Launching App');
    return BlocProvider(
      create: (context) => PlatformBloc(),
      child: const AppView(),
    );
    // return BlocProvider(
    //   create: (_) => PlatformBloc(),
    //   child: const AppView(),
    // );
  }
}
