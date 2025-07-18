import 'package:flutter/material.dart';
import 'package:shmr_finance_app/domain/controllers/biometric/biometric_controller.dart';

class BiometricAuthSwitch extends StatelessWidget {
  const BiometricAuthSwitch({required this.biometricController, super.key});

  final BiometricController biometricController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SwitchListTile(
      title: Text(
        'Включить аутентификацию по отпечатку пальцев',
        style: theme.textTheme.bodyLarge,
      ),
      value: biometricController.isBiometricEnabled,
      onChanged: (value) async {
        await biometricController.setBiometricEnabled(isEnabled: value);
      },
    );
  }
}
