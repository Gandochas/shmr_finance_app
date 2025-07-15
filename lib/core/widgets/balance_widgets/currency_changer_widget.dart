import 'package:flutter/material.dart';

class CurrencyChangerWidget extends StatelessWidget {
  const CurrencyChangerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          leading: Text('₽', style: theme.textTheme.bodyLarge),
          title: Text('Российский рубль ₽', style: theme.textTheme.bodyLarge),
          onTap: () => Navigator.of(context).pop('₽'),
        ),

        Divider(height: 1, color: theme.dividerColor),

        ListTile(
          leading: Text(r'$', style: theme.textTheme.bodyLarge),
          title: Text(
            r'Американский доллар $',
            style: theme.textTheme.bodyLarge,
          ),
          onTap: () => Navigator.of(context).pop(r'$'),
        ),

        Divider(height: 1, color: Theme.of(context).dividerColor),

        ListTile(
          leading: Text('€', style: theme.textTheme.bodyLarge),
          title: Text('Евро €', style: theme.textTheme.bodyLarge),
          onTap: () => Navigator.of(context).pop('€'),
        ),

        ListTile(
          tileColor: theme.colorScheme.error,
          leading: const Icon(Icons.close),
          title: Text('Отмена', style: theme.textTheme.bodyLarge),
          onTap: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
