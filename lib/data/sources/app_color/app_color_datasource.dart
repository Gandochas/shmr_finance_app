import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

final class AppColorDatasource {
  AppColorDatasource({required SharedPreferences preferences})
    : _preferences = preferences;

  final SharedPreferences _preferences;

  Future<Color> loadPrimaryColor() async {
    final colorHex = _preferences.getString('app_primary_color') ?? '2AE881';
    return Color(int.parse('0xFF$colorHex'));
  }

  Future<void> setPrimaryColor(String colorHex) async {
    await _preferences.setString('app_primary_color', colorHex);
  }
}
