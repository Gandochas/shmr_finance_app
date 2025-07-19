import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shmr_finance_app/domain/controllers/haptic_touch/haptic_touch_controller.dart';
import 'package:shmr_finance_app/l10n/app_localizations.dart';

class HapticTouchSwitch extends StatelessWidget {
  const HapticTouchSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Consumer<HapticTouchController>(
      builder: (context, hapticTouchController, child) {
        return SwitchListTile(
          title: Text(
            localization.haptic_touch,
            style: theme.textTheme.bodyLarge,
          ),
          value: hapticTouchController.isHapticFeedbackEnabled,
          onChanged: (value) async {
            await hapticTouchController.toggleHapticFeedback(value: value);
          },
        );
      },
    );
  }
}
