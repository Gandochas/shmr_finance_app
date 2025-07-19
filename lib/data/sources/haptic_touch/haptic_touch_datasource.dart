import 'package:shared_preferences/shared_preferences.dart';

final class HapticTouchDatasource {
  HapticTouchDatasource({required SharedPreferences preferences})
    : _preferences = preferences;

  final SharedPreferences _preferences;

  static const sharedPrefsKey = 'haptic_feedback_enabled';

  Future<bool> loadHapticFeedback() async {
    final isHapticEnabled = _preferences.getBool(sharedPrefsKey);
    return isHapticEnabled ?? false;
  }

  Future<void> saveHapticFeedback({required bool value}) async {
    await _preferences.setBool(sharedPrefsKey, value);
  }
}
