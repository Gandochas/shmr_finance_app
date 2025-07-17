import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:shmr_finance_app/domain/controllers/app_color_controller.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppColorController>(
      builder: (context, appColorController, child) {
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
                  title: Text(
                    'Системная тема',
                    style: theme.textTheme.bodyLarge,
                  ),
                  trailing: Switch.adaptive(
                    value: false,
                    onChanged: (value) {},
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: theme.dividerColor)),
                ),
                child: ListTile(
                  title: Text(
                    'Основной цвет',
                    style: theme.textTheme.bodyLarge,
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              'Выберите основной цвет приложения',
                            ),
                            content: BlockPicker(
                              pickerColor: appColorController.primaryColor,
                              onColorChanged: (color) {
                                appColorController.setPrimaryColor(color);
                              },
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('Отмена'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  appColorController.load();
                                },
                                child: const Text('Применить'),
                              ),
                            ],
                          );
                        },
                      );
                    },
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
      },
    );
  }
}
