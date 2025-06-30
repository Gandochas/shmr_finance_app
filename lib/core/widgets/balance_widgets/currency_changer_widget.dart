import 'package:flutter/material.dart';

class CurrencyChangerWidget extends StatelessWidget {
  const CurrencyChangerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        ListTile(
          leading: Text('₽', style: Theme.of(context).textTheme.bodyLarge),
          title: Text(
            'Российский рубль ₽',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          onTap: () => Navigator.of(context).pop('₽'),
        ),
        Divider(height: 1, color: Theme.of(context).dividerColor),
        ListTile(
          leading: Text(r'$', style: Theme.of(context).textTheme.bodyLarge),
          title: Text(
            r'Американский доллар $',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          onTap: () => Navigator.of(context).pop(r'$'),
        ),
        Divider(height: 1, color: Theme.of(context).dividerColor),
        ListTile(
          leading: Text('€', style: Theme.of(context).textTheme.bodyLarge),
          title: Text('Евро €', style: Theme.of(context).textTheme.bodyLarge),
          onTap: () => Navigator.of(context).pop('€'),
        ),
        ListTile(
          tileColor: Theme.of(context).colorScheme.error,
          leading: const Icon(Icons.close),
          title: const Text('Отмена'),
          onTap: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
