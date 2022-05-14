import 'package:blindytesty/src/platform/platform.dart';
import 'package:blindytesty/src/services/providers/theme_provider.dart';
import 'package:blindytesty/src/widgets/appbar.dart';
import 'package:blindytesty/src/youtube/bloc/youtube_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class YoutubeModeView extends StatefulWidget {
  const YoutubeModeView({Key? key}) : super(key: key);

  @override
  State<YoutubeModeView> createState() => _YoutubeModeViewState();
}

class _YoutubeModeViewState extends State<YoutubeModeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        fullTitle: const Text('Youtube'),
        backArrowAction: () {
          context.read<PlatformBloc>().add(PlatformUnset());
        },
      ),
      body: const Center(
        child: Text('Coming soon.'),
      ),
    );
  }
}

class YoutubeModePage extends StatelessWidget {
  const YoutubeModePage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(builder: (_) => const YoutubeModePage());
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('YoutubeMode page bloc provider');
    }
    return Consumer<ThemeProvider>(builder: (context, themeProvider, _) {
      // themeProvider.setSelectedPrimaryColor(Palette.youtube['red']!);
      return BlocProvider(
        create: (_) => YoutubeBloc(),
        child: const YoutubeModeView(),
      );
    });
  }
}
