import 'package:shared_preferences/shared_preferences.dart';

final class BiometricDatasource {
  BiometricDatasource({required SharedPreferences preferences})
    : _preferences = preferences;

  final SharedPreferences _preferences;

  static const sharedPrefsKey = 'biometric_enabled';

  Future<void> saveBiometricEnabled({required bool isEnabled}) async {
    await _preferences.setBool(sharedPrefsKey, isEnabled);
  }

  Future<bool> isBiometricEnabled() async {
    final isBiometricEnabled = _preferences.getBool(sharedPrefsKey);
    return isBiometricEnabled ?? false;
  }
}
