import 'package:shared_preferences/shared_preferences.dart';

final class AppThemeDatasource {
  AppThemeDatasource({required SharedPreferences preferences})
    : _preferences = preferences;

  final SharedPreferences _preferences;

  static const sharedPrefsKey = 'isSystemTheme';

  Future<bool> loadSystemTheme() async {
    final isSystem = _preferences.getBool(sharedPrefsKey);
    return isSystem ?? false;
  }

  Future<void> saveSystemTheme({required bool value}) async {
    await _preferences.setBool(sharedPrefsKey, value);
  }
}
