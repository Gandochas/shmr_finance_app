import 'package:flutter/material.dart';
import 'package:shmr_finance_app/domain/controllers/app_theme/app_theme_controller.dart';

class SystemThemeSwitch extends StatelessWidget {
  const SystemThemeSwitch({required this.appThemeController, super.key});

  final AppThemeController appThemeController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      title: Text('Системная тема', style: theme.textTheme.bodyLarge),
      trailing: Switch.adaptive(
        value: appThemeController.isSystemTheme,
        onChanged: (value) async {
          await appThemeController.switchTheme(newValue: value);
        },
      ),
    );
  }
}
