import 'package:shared_preferences/shared_preferences.dart';

class HapticTouchDatasource {
  HapticTouchDatasource({required SharedPreferences preferences})
    : _preferences = preferences;

  final SharedPreferences _preferences;

  Future<bool> loadHapticFeedback() async {
    final isHapticEnabled = _preferences.getBool('haptic_feedback_enabled');
    return isHapticEnabled ?? false;
  }

  Future<void> saveHapticFeedback({required bool value}) async {
    await _preferences.setBool('haptic_feedback_enabled', value);
  }
}
