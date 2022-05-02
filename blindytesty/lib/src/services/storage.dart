import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/models.dart';

/// Handles all the storage using Hive
class Storage {
  static const String defaultSpotifyClientID =
      "0c9ef2bc7b2a4189b06ed071c7dd0dfd";

  static var settingsStorage = Hive.box<SettingsObject>('settings');
  static var spotifyCredentialsStorage =
      Hive.box<SpotifyCredentialsObject>('spotifyCredentials');

  static final settingsStorageStream =
      Hive.box<SettingsObject>('settings').listenable();
  static final spotifyCredentialsStorageStream =
      Hive.box<SpotifyCredentialsObject>('spotifyCredentials').listenable();

  static Future<void> initStorage() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();

    Hive.registerAdapter(SettingsObjectAdapter());
    Hive.registerAdapter(SpotifyCredentialsObjectAdapter());

    await Hive.openBox<SettingsObject>('settings');
    await Hive.openBox<SpotifyCredentialsObject>('spotifyCredentials');
  }

  static SpotifyCredentialsObject? getSpotifyCredentials() {
    return spotifyCredentialsStorage.get('spotifyCredentials');
  }

  static void deleteSpotifyCredentials() {
    SpotifyCredentialsObject? creds =
        spotifyCredentialsStorage.get('spotifyCredentials');
    if (creds != null) {
      creds.delete();
    }
  }

  static void setSpotifyCredentials(SpotifyCredentialsObject creds) {
    spotifyCredentialsStorage.put('spotifyCredentials', creds);
  }

  static SettingsObject getSettings() {
    SettingsObject? settings = settingsStorage.get('settings');
    return settings ?? SettingsObject();
  }

  static void setSettings(SettingsObject? settings) {
    settingsStorage.put('settings', settings ?? SettingsObject());
  }
}
