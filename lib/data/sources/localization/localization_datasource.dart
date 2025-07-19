import 'package:shared_preferences/shared_preferences.dart';

final class LocalizationDatasource {
  LocalizationDatasource({required SharedPreferences preferences})
    : _preferences = preferences;

  final SharedPreferences _preferences;

  Future<String> loadLocalization() async {
    final localization = _preferences.getString('language');
    return localization ?? 'en';
  }

  Future<void> saveLocalization(String languageCode) async {
    await _preferences.setString('language', languageCode);
  }
}
