import 'package:flutter/material.dart';
import 'package:shmr_finance_app/data/sources/app_theme/app_theme_datasource.dart';

final class AppThemeController extends ChangeNotifier {
  AppThemeController({required AppThemeDatasource appThemeDatasource})
    : _appThemeDatasource = appThemeDatasource,
      _isSystemTheme = false;

  final AppThemeDatasource _appThemeDatasource;
  bool _isSystemTheme;

  bool get isSystemTheme => _isSystemTheme;

  Future<void> switchTheme({required bool newValue}) async {
    _isSystemTheme = newValue;
    await _appThemeDatasource.saveSystemTheme(value: _isSystemTheme);
    notifyListeners();
  }

  Future<void> load() async {
    _isSystemTheme = await _appThemeDatasource.loadSystemTheme();
    notifyListeners();
  }
}
