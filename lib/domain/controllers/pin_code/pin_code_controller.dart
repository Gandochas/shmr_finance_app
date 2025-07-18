import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shmr_finance_app/data/sources/pin_code/pin_code_datasource.dart';

class PinCodeController extends ChangeNotifier {
  PinCodeController({required PinCodeDatasource pinCodeDatasource})
    : _pinCodeDatasource = pinCodeDatasource;

  final PinCodeDatasource _pinCodeDatasource;
  String? _pinCode;
  int _attemptsLeft = 3;

  String? get pinCode => _pinCode;
  int get attemptsLeft => _attemptsLeft;

  Future<void> setPinCode(String pinCode) async {
    if (pinCode.length == 4) {
      _pinCode = pinCode;
      await _pinCodeDatasource.savePinCode(pinCode);
      notifyListeners();
    } else {
      throw Exception('Pincode must be 4 digits long!');
    }
  }

  Future<void> loadPinCode() async {
    _pinCode = await _pinCodeDatasource.getPinCode();
    notifyListeners();
  }

  Future<void> deletePinCode() async {
    _pinCode = null;
    await _pinCodeDatasource.deletePinCode();
    notifyListeners();
  }

  bool isPinCodeCorrect(String pinCode) {
    if (_pinCode == null) return false;
    if (_pinCode == pinCode) {
      _attemptsLeft = 3;
      return true;
    } else {
      _attemptsLeft--;
      if (_attemptsLeft == 0) SystemNavigator.pop();
      return false;
    }
  }
}
