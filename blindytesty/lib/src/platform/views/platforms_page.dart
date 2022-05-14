import 'package:blindytesty/src/services/providers/theme_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:blindytesty/src/platform/platform.dart';
import 'package:blindytesty/src/widgets/widgets.dart';
import 'package:blindytesty/color_palettes.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PlatformSelectionPage extends StatelessWidget {
  const PlatformSelectionPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
        builder: (_) => const PlatformSelectionPage());
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) print('Launching Platform Selection Page');

    // Main View
    return Consumer<ThemeProvider>(builder: (context, themeProvider, _) {
      return Scaffold(
        appBar: CustomAppBar(
          fullTitle: const Text('Blindy Testy'),
          // actions: [
          //   (themeProvider.selectedThemeMode == ThemeMode.light)
          //       ? IconButton(
          //           onPressed: () {
          //             themeProvider.setSelectedThemeMode(ThemeMode.dark);
          //           },
          //           icon: const Icon(Icons.dark_mode),
          //         )
          //       : IconButton(
          //           onPressed: () {
          //             themeProvider.setSelectedThemeMode(ThemeMode.light);
          //           },
          //           icon: const Icon(Icons.light_mode),
          //         ),
          // ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: BouncyScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Which music provider do you want to use?',
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                ),
                const Padding(padding: EdgeInsets.all(30)),
                Tooltip(
                  message: (kIsWeb)
                      ? 'Local files are not accessible on a browser.'
                      : '',
                  child: SelectionButton(
                    onPressed: kIsWeb
                        ? null
                        : () {
                            context
                                .read<PlatformBloc>()
                                .add(const PlatformChanged('local'));
                          },
                    fontSize: 30,
                    child: const Text('Local files'),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(12)),
                SelectionButton(
                  onPressed: () {
                    context
                        .read<PlatformBloc>()
                        .add(const PlatformChanged('spotify'));
                  },
                  background: Palette.spotify['green'],
                  foreground: Palette.spotify['blackSolid'],
                  child: Image.asset(
                    "assets/spotify/Spotify_Logo_RGB_Black.png",
                    isAntiAlias: true,
                    width: 150.0,
                  ),
                ),
                const Padding(padding: EdgeInsets.all(12)),
                SelectionButton(
                  onPressed: () {
                    context
                        .read<PlatformBloc>()
                        .add(const PlatformChanged('youtube'));
                  },
                  background: Palette.youtube['red'],
                  foreground: Palette.spotify['blackSolid'],
                  child: Image.asset(
                    "assets/youtube/youtube_monochrome_logos/digital_and_tv/yt_logo_mono_dark.png",
                    isAntiAlias: true,
                    width: 150.0,
                  ),
                ),
                const Padding(padding: EdgeInsets.all(30)),
                Builder(builder: (context) {
                  List<Widget> widgets = [];
                  if (!kIsWeb) {
                    widgets.add(
                      ElevatedButton(
                        onPressed: () {
                          launchUrl(
                              Uri.parse(
                                  'https://yorodoes.github.io/BlindyTesty'),
                              mode: LaunchMode.externalApplication);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(0, 70),
                        ),
                        child: const Text(
                          'Test the website version',
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                      ),
                    );
                  }
                  widgets.add(
                    ElevatedButton(
                      onPressed: () {
                        launchUrl(
                            Uri.parse(
                                'https://github.com/YoroDoes/BlindyTesty/releases/latest'),
                            mode: LaunchMode.externalApplication);
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 70),
                      ),
                      child: const Text(
                        'Get Blindy Testy on other platforms!',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ),
                  );

                  return Wrap(
                    alignment: WrapAlignment.center,
                    direction: Axis.horizontal,
                    spacing: 20,
                    runSpacing: 20,
                    // children: [
                    //   Text('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'),
                    //   Text(
                    //       'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'),
                    // ],
                    children: widgets,
                  );
                }),
              ],
            ),
          ),
        ),
      );
    });
  }
}
