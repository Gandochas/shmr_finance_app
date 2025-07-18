import 'package:flutter/material.dart';
import 'package:shmr_finance_app/data/sources/biometric/biometric_datasource.dart';

class BiometricController extends ChangeNotifier {
  BiometricController({required BiometricDatasource biometricDatasource})
    : _biometricDatasource = biometricDatasource,
      _isBiometricEnabled = false;

  final BiometricDatasource _biometricDatasource;
  bool _isBiometricEnabled;

  bool get isBiometricEnabled => _isBiometricEnabled;

  Future<void> loadBiometricSetting() async {
    _isBiometricEnabled = await _biometricDatasource.isBiometricEnabled();
    notifyListeners();
  }

  Future<void> setBiometricEnabled({required bool isEnabled}) async {
    _isBiometricEnabled = isEnabled;
    await _biometricDatasource.saveBiometricEnabled(
      isEnabled: _isBiometricEnabled,
    );
    notifyListeners();
  }
}
