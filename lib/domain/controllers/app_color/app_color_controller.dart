import 'package:flutter/material.dart';
import 'package:shmr_finance_app/data/sources/app_color/app_color_datasource.dart';

final class AppColorController extends ChangeNotifier {
  AppColorController({required AppColorDatasource appColorDatasource})
    : _appColorDatasource = appColorDatasource,
      _primaryColor = const Color(0xFF2AE881);

  final AppColorDatasource _appColorDatasource;
  Color _primaryColor;

  Color get primaryColor => _primaryColor;

  Future<void> load() async {
    _primaryColor = await _appColorDatasource.loadPrimaryColor();
    notifyListeners();
  }

  Future<void> setPrimaryColor(Color color) async {
    _primaryColor = color;
    final colorHex = _primaryColor
        .toARGB32()
        .toRadixString(16)
        .substring(2)
        .toUpperCase();
    await _appColorDatasource.setPrimaryColor(colorHex);
    notifyListeners();
  }
}
