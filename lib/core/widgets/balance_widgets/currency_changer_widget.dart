import 'package:flutter/material.dart';
import 'package:shmr_finance_app/l10n/app_localizations.dart';

class CurrencyChangerWidget extends StatelessWidget {
  const CurrencyChangerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: theme.dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),

        ListTile(
          leading: Text(
            localization.russian_ruble_sign,
            style: theme.textTheme.bodyLarge,
          ),
          title: Text(
            '${localization.russian_ruble} ${localization.russian_ruble_sign}',
            style: theme.textTheme.bodyLarge,
          ),
          onTap: () =>
              Navigator.of(context).pop(localization.russian_ruble_sign),
        ),

        Divider(height: 1, color: theme.dividerColor),

        ListTile(
          leading: Text(
            localization.american_dollar_sign,
            style: theme.textTheme.bodyLarge,
          ),
          title: Text(
            '${localization.american_dollar} ${localization.american_dollar_sign}',
            style: theme.textTheme.bodyLarge,
          ),
          onTap: () =>
              Navigator.of(context).pop(localization.american_dollar_sign),
        ),

        Divider(height: 1, color: Theme.of(context).dividerColor),

        ListTile(
          leading: Text(
            localization.euro_sign,
            style: theme.textTheme.bodyLarge,
          ),
          title: Text(
            '${localization.euro} ${localization.euro_sign}',
            style: theme.textTheme.bodyLarge,
          ),
          onTap: () => Navigator.of(context).pop(localization.euro_sign),
        ),

        ListTile(
          tileColor: theme.colorScheme.error,
          leading: const Icon(Icons.close),
          title: Text(localization.cancel, style: theme.textTheme.bodyLarge),
          onTap: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
