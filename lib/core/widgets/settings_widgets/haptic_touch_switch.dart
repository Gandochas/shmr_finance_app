import 'package:flutter/material.dart';
import 'package:shmr_finance_app/domain/controllers/haptic_touch/haptic_touch_controller.dart';
import 'package:shmr_finance_app/l10n/app_localizations.dart';

class HapticTouchSwitch extends StatelessWidget {
  const HapticTouchSwitch({required this.hapticTouchController, super.key});

  final HapticTouchController hapticTouchController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return ListTile(
      title: Text(localization.haptic_touch, style: theme.textTheme.bodyLarge),
      trailing: Switch.adaptive(
        value: hapticTouchController.isHapticFeedbackEnabled,
        onChanged: (value) async {
          await hapticTouchController.toggleHapticFeedback(value: value);
        },
      ),
    );
  }
}
