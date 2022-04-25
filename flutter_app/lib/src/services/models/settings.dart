import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'settings.g.dart';

@HiveType(typeId: 0)
class SettingsObject extends HiveObject {
  SettingsObject();

  @HiveField(0)
  String? selectedPlatform;

  @HiveField(1)
  bool darkMode = true;
}
