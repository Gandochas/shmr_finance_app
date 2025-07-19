import 'package:flutter/material.dart';
import 'package:shmr_finance_app/data/sources/localization/localization_datasource.dart';

final class LocalizationController extends ChangeNotifier {
  LocalizationController({
    required LocalizationDatasource localizationDatasource,
  }) : _localizationDatasource = localizationDatasource,
       _languageCode = 'en';

  final LocalizationDatasource _localizationDatasource;

  String _languageCode;
  String get languageCode => _languageCode;

  Future<void> loadLocalization() async {
    _languageCode = await _localizationDatasource.loadLocalization();
    notifyListeners();
  }

  Future<void> setLocalization(String languageCode) async {
    _languageCode = languageCode;
    await _localizationDatasource.saveLocalization(_languageCode);
    notifyListeners();
  }
}
