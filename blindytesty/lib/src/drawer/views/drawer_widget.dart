import 'package:blindytesty/src/spotify/auth/bloc/spotify_auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:blindytesty/src/platform/platform.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blindytesty/color_palettes.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key? key, required this.page}) : super(key: key);

  final String page;

  @override
  Widget build(BuildContext context) {
    // Platform specific widgets
    final Widget header, headerStyle;
    Set<Widget> footer = {};
    switch (page) {
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
              //TODO to test
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
        header = const Center(
          heightFactor: 0,
          widthFactor: 0,
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
            children: [
              Hero(
                tag: 'logo',
                child: Image.asset(
                  "assets/spotify/Spotify_Logo_RGB_Black.png",
                  width: 20,
                ),
              ),
              const Text('Use Spotify'),
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
          height: 145,
          child: Column(
            children: [
              const Divider(height: 0, thickness: 2),
              ListTile(
                title: const Text("Help"),
                leading: const Icon(Icons.help_outline_outlined),
                onTap: () {},
              ),
              ...footer,
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
    return (page != forPage
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
