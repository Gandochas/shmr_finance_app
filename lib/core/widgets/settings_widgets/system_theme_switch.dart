import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shmr_finance_app/domain/controllers/app_theme/app_theme_controller.dart';
import 'package:shmr_finance_app/l10n/app_localizations.dart';

class SystemThemeSwitch extends StatelessWidget {
  const SystemThemeSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Consumer<AppThemeController>(
      builder: (context, appThemeController, child) {
        return ListTile(
          title: Text(
            localization.enable_system_theme,
            style: theme.textTheme.bodyLarge,
          ),
          trailing: Switch.adaptive(
            value: appThemeController.isSystemTheme,
            onChanged: (value) async {
              await appThemeController.switchTheme(newValue: value);
            },
          ),
        );
      },
    );
  }
}
