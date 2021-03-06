import 'package:blindytesty/src/spotify/auth/bloc/spotify_auth_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:blindytesty/src/platform/platform.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blindytesty/color_palettes.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({Key? key, required this.page}) : super(key: key);

  final String page;

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  PackageInfo? _packageInfo;

  @override
  Widget build(BuildContext context) {
    // Platform specific widgets
    Future(() async {
      var packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _packageInfo = packageInfo;
      });
    });
    final Widget header;
    Set<Widget> footer = {};
    switch (widget.page) {
      case 'local':
        header = const DrawerHeader(
          // decoration: BoxDecoration(
          //   color: Palette.local['green'],
          // ),
          child: Text('Local Songs'),
        );
        break;
      case 'spotify':
        header = DrawerHeader(
          decoration: BoxDecoration(
            color: Palette.spotify['green'],
          ),
          child: Image.asset(
            "assets/spotify/Spotify_Logo_RGB_White.png",
            height: 20,
            fit: BoxFit.fitWidth,
            color: Palette.spotify['blackSolid'],
          ),
        );
        footer = {
          ListTile(
            title: const Text("Settings"),
            leading: const Icon(Icons.settings_outlined),
            onTap: () {
              //TODO settings
            },
          ),
          ListTile(
            title: const Text("Log Out from spotify"),
            leading: const Icon(Icons.logout_outlined),
            onTap: () {
              context.read<SpotifyAuthBloc>().add(const SpotifyDisconnect());
            },
          ),
        };
        break;
      case 'youtube':
        header = DrawerHeader(
          decoration: BoxDecoration(
            color: Palette.youtube['red'],
          ),
          child: const Text('Youtube'),
        );
        break;
      default:
        header = DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.primaries[5],
          ),
          child: const Text(
            'Get Blindy Testy',
            style: TextStyle(fontSize: 30),
          ),
        );
        break;
    }

    final List<Widget> pages = [
      pageListTile(
          forPage: 'home',
          title: const Text('Home page'),
          onTap: () {
            context.read<PlatformBloc>().add(PlatformUnset());
          }),
      pageListTile(
          forPage: 'local',
          title: const Text('Use local songs'),
          onTap: () {
            context.read<PlatformBloc>().add(const PlatformChanged('local'));
          }),
      pageListTile(
          forPage: 'spotify',
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Use Spotify'),
              const Padding(padding: EdgeInsets.symmetric(horizontal: 3)),
              Hero(
                tag: 'logo',
                child: Image.asset(
                  "assets/spotify/Spotify_Icon_RGB_Green.png",
                  width: 30,
                ),
              ),
            ],
          ),
          onTap: () {
            context.read<PlatformBloc>().add(const PlatformChanged('spotify'));
          }),
      pageListTile(
          forPage: 'youtube',
          title: const Text('Use Youtube songs'),
          onTap: () {
            context.read<PlatformBloc>().add(const PlatformChanged('youtube'));
          }),
      pageListTile(
          forPage: 'other_platforms',
          title: const Text(kIsWeb
              ? 'Get Blindy Testy on other platforms!'
              : 'Test the website version.'),
          onTap: () {
            if (kIsWeb) {
              launchUrl(
                  Uri.parse(
                      'https://github.com/YoroDoes/BlindyTesty/releases/latest'),
                  mode: LaunchMode.externalApplication);
            } else {
              launchUrl(Uri.parse('https://yorodoes.github.io/BlindyTesty'),
                  mode: LaunchMode.externalApplication);
            }
          }),
    ];

    return Drawer(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(144),
          child: header,
        ),
        body: ListView(
          children: [
            ...pages,
          ],
        ),
        bottomNavigationBar: SizedBox(
          height: ((footer.length + 1) * 52) + 10,
          child: Column(
            children: [
              const Divider(height: 0, thickness: 2),
              ListTile(
                title: const Text("Help"),
                leading: const Icon(Icons.help_outline_outlined),
                onTap: () {},
              ),
              ...footer,
              Builder(builder: (context) {
                String buildName = (_packageInfo?.buildNumber ?? '').isNotEmpty
                    ? '+${_packageInfo?.buildNumber}'
                    : '';
                return Text(
                  '${_packageInfo?.appName}: '
                  'v${_packageInfo?.version}$buildName',
                  style: const TextStyle(fontSize: 12),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget pageListTile(
      {required String forPage,
      required Widget title,
      required dynamic onTap}) {
    return (widget.page != forPage
        ? ListTile(
            title: title,
            onTap: onTap,
          )
        : const Center(
            heightFactor: 0.0,
            widthFactor: 0.0,
          ));
  }
}
