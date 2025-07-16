import 'package:flutter/material.dart';
import 'package:shmr_finance_app/data/sources/app_color/app_color_datasource.dart';

final class AppColorController extends ChangeNotifier {
  AppColorController({required AppColorDatasource appColorDatasource})
    : _appColorDatasource = appColorDatasource;

  final AppColorDatasource _appColorDatasource;

  Color get primaryColor => _appColorDatasource.getPrimaryColor();

  Future<void> setPrimaryColor(Color color) async {
    final colorHex = color
        .toARGB32()
        .toRadixString(16)
        .substring(2)
        .toUpperCase();
    await _appColorDatasource.setPrimaryColor(colorHex);
    notifyListeners();
  }
}
