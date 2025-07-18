import 'package:flutter/material.dart';
import 'package:shmr_finance_app/data/sources/haptic_touch/haptic_touch_datasource.dart';

class HapticTouchController extends ChangeNotifier {
  HapticTouchController({
    required HapticTouchDatasource hapticFeedbackDatasource,
  }) : _hapticFeedbackDatasource = hapticFeedbackDatasource,
       _isHapticFeedbackEnabled = false;

  final HapticTouchDatasource _hapticFeedbackDatasource;
  bool _isHapticFeedbackEnabled;

  bool get isHapticFeedbackEnabled => _isHapticFeedbackEnabled;

  Future<void> toggleHapticFeedback({required bool value}) async {
    _isHapticFeedbackEnabled = value;
    await _hapticFeedbackDatasource.saveHapticFeedback(
      value: _isHapticFeedbackEnabled,
    );
    notifyListeners();
  }

  Future<void> load() async {
    _isHapticFeedbackEnabled = await _hapticFeedbackDatasource
        .loadHapticFeedback();
    notifyListeners();
  }
}
