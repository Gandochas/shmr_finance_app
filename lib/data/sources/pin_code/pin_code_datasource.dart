import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinCodeDatasource {
  PinCodeDatasource({required FlutterSecureStorage secureStorage})
    : _secureStorage = secureStorage;

  final FlutterSecureStorage _secureStorage;

  Future<void> savePinCode(String pinCode) async {
    await _secureStorage.write(key: 'pin_code', value: pinCode);
  }

  Future<String?> getPinCode() async {
    return _secureStorage.read(key: 'pin_code');
  }

  Future<void> deletePinCode() async {
    await _secureStorage.delete(key: 'pin_code');
  }
}
