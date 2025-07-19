import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shmr_finance_app/domain/controllers/localization/localization_controller.dart';
import 'package:shmr_finance_app/l10n/app_localizations.dart';

class LocalizationChanger extends StatelessWidget {
  const LocalizationChanger({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Consumer<LocalizationController>(
      builder: (context, localizationController, child) {
        return ListTile(
          title: Text(localization.language, style: theme.textTheme.bodyLarge),
          trailing: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              items: [
                DropdownMenuItem(
                  value: 'en',
                  child: Text(
                    localization.english,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
                DropdownMenuItem(
                  value: 'ru',
                  child: Text(
                    localization.russian,
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
              ],
              onChanged: (newValue) {
                if (newValue != null) {
                  localizationController.setLocalization(newValue);
                }
              },
              value: localizationController.languageCode,
            ),
          ),
        );
      },
    );
  }
}
