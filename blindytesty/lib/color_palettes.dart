import 'package:flutter/material.dart';

class Palette {
  static Map<String, Color> spotify = {
        'green': const Color.fromARGB(255, 123, 189, 0),
        'blackSolid': Colors.black,
        'greySolid': const Color.fromARGB(255, 130, 130, 130),
        'sandSolid': const Color.fromARGB(255, 236, 235, 232),
        'whiteSolid': Colors.white,
      },
      youtube = {
        'red': Colors.red,
        'blackSolid': const Color.fromARGB(255, 40, 40, 40),
      },
      normal = {
        'blue': Colors.blue,
        'blackSolid': const Color.fromARGB(255, 40, 40, 40),
      };

  static Color getShade(Color color, {bool darker = false, double value = .1}) {
    assert(value >= 0 && value <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness(
        (darker ? (hsl.lightness - value) : (hsl.lightness + value))
            .clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  static MaterialColor getMaterialColorFromColor(Color color) {
    Map<int, Color> colorShades = {
      50: getShade(color, value: 0.5),
      100: getShade(color, value: 0.4),
      200: getShade(color, value: 0.3),
      300: getShade(color, value: 0.2),
      400: getShade(color, value: 0.1),
      500: color,
      600: getShade(color, value: 0.1, darker: true),
      700: getShade(color, value: 0.15, darker: true),
      800: getShade(color, value: 0.2, darker: true),
      900: getShade(color, value: 0.25, darker: true),
    };
    return MaterialColor(color.value, colorShades);
  }
}
