import 'package:flutter/material.dart';
import 'package:shmr_finance_app/domain/controllers/haptic_touch/haptic_touch_controller.dart';

class HapticTouchSwitch extends StatelessWidget {
  const HapticTouchSwitch({required this.hapticTouchController, super.key});

  final HapticTouchController hapticTouchController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      title: Text('Хаптики', style: theme.textTheme.bodyLarge),
      trailing: Switch.adaptive(
        value: hapticTouchController.isHapticFeedbackEnabled,
        onChanged: (value) async {
          await hapticTouchController.toggleHapticFeedback(value: value);
        },
      ),
    );
  }
}
