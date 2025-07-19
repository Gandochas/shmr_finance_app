import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final class PinCodeDatasource {
  PinCodeDatasource({required FlutterSecureStorage secureStorage})
    : _secureStorage = secureStorage;

  final FlutterSecureStorage _secureStorage;

  static const sharedPrefsKey = 'pin_code';

  Future<void> savePinCode(String pinCode) async {
    await _secureStorage.write(key: sharedPrefsKey, value: pinCode);
  }

  Future<String?> getPinCode() async {
    return _secureStorage.read(key: sharedPrefsKey);
  }

  Future<void> deletePinCode() async {
    await _secureStorage.delete(key: sharedPrefsKey);
  }
}
