import 'dart:io';

import 'package:blindytesty/src/drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:overlay_support/overlay_support.dart';

class OtherPlatformsPage extends StatelessWidget {
  const OtherPlatformsPage({Key? key}) : super(key: key);

  static MaterialPageRoute route() => MaterialPageRoute(
        builder: (context) => const OtherPlatformsPage(),
      );

  @override
  Widget build(BuildContext context) {
    List<Widget> grid = [];

    if (!kIsWeb) {
      grid.add(platformButton(
          title: 'Web',
          action: () {
            showSimpleNotification(
              const Text('Opening web page.'),
              background: Colors.green,
              slideDismissDirection: DismissDirection.up,
            );
            launchUrl(Uri.parse('https://yorodoes.github.io/BlindyTesty'),
                mode: LaunchMode.externalApplication);
          }));
    }
    if (kIsWeb || !Platform.isAndroid) {
      grid.add(platformButton(
          title: 'Android',
          action: () {
            showSimpleNotification(
              const Text('Coming soon.'),
              background: Colors.orange.shade700,
              slideDismissDirection: DismissDirection.up,
            );
          }));
    }
    if (kIsWeb || !Platform.isIOS) {
      grid.add(platformButton(
          title: 'iOS',
          action: () {
            showSimpleNotification(
              const Text('Coming soon.'),
              background: Colors.orange.shade700,
              slideDismissDirection: DismissDirection.up,
            );
          }));
    }
    if (kIsWeb || !Platform.isWindows) {
      grid.add(platformButton(
          title: 'Windows',
          action: () {
            showSimpleNotification(
              const Text('Coming soon.'),
              background: Colors.orange.shade700,
              slideDismissDirection: DismissDirection.up,
            );
          }));
    }
    if (kIsWeb || !Platform.isMacOS) {
      grid.add(platformButton(
          title: 'MacOS',
          action: () {
            showSimpleNotification(
              const Text('Coming soon.'),
              background: Colors.orange.shade700,
              slideDismissDirection: DismissDirection.up,
            );
          }));
    }
    if (kIsWeb || !Platform.isLinux) {
      grid.add(platformButton(
          title: 'Linux',
          action: () {
            showSimpleNotification(
              const Text('Coming soon.'),
              background: Colors.orange.shade700,
              slideDismissDirection: DismissDirection.up,
            );
          }));
    }
    if (kIsWeb || !Platform.isFuchsia) {
      grid.add(platformButton(
          title: 'Fushcia',
          action: () {
            showSimpleNotification(
              const Text('Coming soon.'),
              background: Colors.orange.shade700,
              slideDismissDirection: DismissDirection.up,
            );
          }));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Get Blindy Testy')),
      drawer: const MenuDrawer(page: 'other_platforms'),
      body: Center(
        child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          crossAxisCount: 6,
          children: [
            ...grid,
          ],
        ),
      ),
    );
  }
}

Widget platformButton(
    {required String title, required void Function() action}) {
  return ElevatedButton(onPressed: action, child: Text(title));
}
