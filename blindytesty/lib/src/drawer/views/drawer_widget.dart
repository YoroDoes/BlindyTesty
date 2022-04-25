import 'package:flutter/material.dart';
import 'package:blindytesty/src/platform/platform.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key? key, required this.page}) : super(key: key);

  final String page;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            child: Text('Menu'),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              context.read<PlatformBloc>().add(PlatformUnset());
            },
          ),
        ],
      ),
    );
  }
}
