import 'package:blindytesty/src/services/models/settings.dart';
import 'package:blindytesty/src/services/storage.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode selectedThemeMode = Storage.getSettings().darkMode == ThemeMode.dark
      ? ThemeMode.dark
      : ThemeMode.light;
  Color selectedPrimaryColor = Colors.lightBlue;

  setSelectedThemeMode(ThemeMode themeMode) {
    selectedThemeMode = themeMode;
    SettingsObject settings = Storage.getSettings();
    settings.darkMode = selectedThemeMode;
    Storage.setSettings(settings);
    notifyListeners();
  }

  setSelectedPrimaryColor(Color color) {
    selectedPrimaryColor = color;
    notifyListeners();
  }
}
