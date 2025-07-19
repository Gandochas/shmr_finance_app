import 'package:shared_preferences/shared_preferences.dart';

class AppThemeDatasource {
  AppThemeDatasource({required SharedPreferences preferences})
    : _preferences = preferences;

  final SharedPreferences _preferences;

  Future<bool> loadSystemTheme() async {
    final isSystem = _preferences.getBool('isSystemTheme');
    return isSystem ?? false;
  }

  Future<void> saveSystemTheme({required bool value}) async {
    await _preferences.setBool('isSystemTheme', value);
  }
}
