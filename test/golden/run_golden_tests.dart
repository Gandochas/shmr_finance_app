import 'dart:io';

import 'package:flutter/material.dart';

void main(List<String> args) async {
  final updateGoldens = args.contains('--update-goldens');

  debugPrint('🧪 Запуск golden тестов TransactionsSumWidget');

  if (updateGoldens) {
    debugPrint('📸 Обновление golden файлов...');
  } else {
    debugPrint('🔍 Сравнение с существующими golden файлами...');
  }

  try {
    final result = await Process.run('flutter', [
      'test',
      'test/golden/transactions_sum_widget/transactions_sum_widget_test.dart',
      if (updateGoldens) '--update-goldens',
      '--reporter=expanded',
    ]);

    final stdout = result.stdout.toString();
    final stderr = result.stderr.toString();

    if (stdout.isNotEmpty) {
      debugPrint(stdout);
    }

    if (stderr.isNotEmpty) {
      debugPrint('❌ Ошибки:');
      debugPrint(stderr);
    }

    if (result.exitCode == 0) {
      debugPrint('\n✅ Все тесты прошли успешно!');
      if (updateGoldens) {
        debugPrint('📸 Golden файлы обновлены.');
      }
    } else {
      debugPrint('\n❌ Некоторые тесты не прошли (код: ${result.exitCode})');
      if (!updateGoldens) {
        debugPrint('\n💡 Если изменения корректны, запустите:');
        debugPrint(
          '   dart test/golden/run_golden_tests.dart --update-goldens',
        );
      }
      exit(result.exitCode);
    }
  } on Object catch (e) {
    debugPrint('❌ Ошибка запуска тестов: $e');
    exit(1);
  }
}
