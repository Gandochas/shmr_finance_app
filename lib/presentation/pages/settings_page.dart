import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Text('Настройки', style: theme.appBarTheme.titleTextStyle),
        centerTitle: true,
      ),
      body: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: theme.dividerColor)),
            ),
            child: ListTile(
              title: Text('Системная тема', style: theme.textTheme.bodyLarge),
              trailing: Switch.adaptive(value: false, onChanged: (value) {}),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: theme.dividerColor)),
            ),
            child: ListTile(
              title: Text('Основной цвет', style: theme.textTheme.bodyLarge),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.navigate_next),
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: theme.dividerColor)),
            ),
            child: ListTile(
              title: Text('Хаптики', style: theme.textTheme.bodyLarge),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.navigate_next),
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: theme.dividerColor)),
            ),
            child: ListTile(
              title: Text('Код пароль', style: theme.textTheme.bodyLarge),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.navigate_next),
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: theme.dividerColor)),
            ),
            child: ListTile(
              title: Text('Язык', style: theme.textTheme.bodyLarge),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.navigate_next),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
