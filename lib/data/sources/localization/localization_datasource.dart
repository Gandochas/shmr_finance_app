import 'package:shared_preferences/shared_preferences.dart';

final class LocalizationDatasource {
  LocalizationDatasource({required SharedPreferences preferences})
    : _preferences = preferences;

  final SharedPreferences _preferences;

  static const sharedPrefsKey = 'language';

  Future<String> loadLocalization() async {
    final localization = _preferences.getString(sharedPrefsKey);
    return localization ?? 'en';
  }

  Future<void> saveLocalization(String languageCode) async {
    await _preferences.setString(sharedPrefsKey, languageCode);
  }
}
