import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'settings.g.dart';

@HiveType(typeId: 0)
class SettingsObject extends HiveObject {
  SettingsObject();

  @HiveField(0)
  String? selectedPlatform;

  @HiveField(2)
  ThemeMode? darkMode = ThemeMode.dark;
}

class ThemeModeAdapter extends TypeAdapter<ThemeMode> {
  @override
  read(BinaryReader reader) {
    final enumAsInt = reader.readInt();
    return ThemeMode.values[enumAsInt];
  }

  @override
  int get typeId => 3;

  @override
  void write(BinaryWriter writer, ThemeMode obj) {
    writer.writeInt(obj.index);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeModeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
