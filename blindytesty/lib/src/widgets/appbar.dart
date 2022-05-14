import 'package:blindytesty/src/services/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({
    Key? key,
    required fullTitle,
    backArrowAction,
    backgroundColor,
    shadowColor,
    foregroundColor,
  }) : super(
          key: key,
          title: Row(
            children: [
              backArrowAction != null
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: backArrowAction,
                    )
                  : const Center(),
              backArrowAction != null
                  ? const Padding(padding: EdgeInsets.all(15.0))
                  : const Center(),
              fullTitle,
            ],
          ),
          // backgroundColor: backgroundColor,
          // shadowColor: shadowColor,
          // foregroundColor: foregroundColor,
          actions: [
            Consumer<ThemeProvider>(builder: (context, themeProvider, _) {
              return (themeProvider.selectedThemeMode == ThemeMode.light)
                  ? IconButton(
                      onPressed: () {
                        themeProvider.setSelectedThemeMode(ThemeMode.dark);
                      },
                      icon: const Icon(Icons.dark_mode),
                    )
                  : IconButton(
                      onPressed: () {
                        themeProvider.setSelectedThemeMode(ThemeMode.light);
                      },
                      icon: const Icon(Icons.light_mode),
                    );
            }),
          ],
        );
}
