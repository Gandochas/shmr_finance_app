import 'package:shared_preferences/shared_preferences.dart';

final class BiometricDatasource {
  BiometricDatasource({required SharedPreferences preferences})
    : _preferences = preferences;

  final SharedPreferences _preferences;

  Future<void> saveBiometricEnabled({required bool isEnabled}) async {
    await _preferences.setBool('biometric_enabled', isEnabled);
  }

  Future<bool> isBiometricEnabled() async {
    final isBiometricEnabled = _preferences.getBool('biometric_enabled');
    return isBiometricEnabled ?? false;
  }
}
