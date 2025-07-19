import 'package:flutter/material.dart';
import 'package:shmr_finance_app/domain/controllers/biometric/biometric_controller.dart';
import 'package:shmr_finance_app/l10n/app_localizations.dart';

class BiometricAuthSwitch extends StatelessWidget {
  const BiometricAuthSwitch({required this.biometricController, super.key});

  final BiometricController biometricController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return SwitchListTile(
      title: Text(
        localization.enable_auth_by_fingerprint,
        style: theme.textTheme.bodyLarge,
      ),
      value: biometricController.isBiometricEnabled,
      onChanged: (value) async {
        await biometricController.setBiometricEnabled(isEnabled: value);
      },
    );
  }
}
