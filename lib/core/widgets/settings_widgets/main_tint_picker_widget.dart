import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shmr_finance_app/domain/controllers/app_color/app_color_controller.dart';

class MainTintPickerWidget extends StatelessWidget {
  const MainTintPickerWidget({required this.appColorController, super.key});

  final AppColorController appColorController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      title: Text('Основной цвет', style: theme.textTheme.bodyLarge),
      trailing: IconButton(
        onPressed: () {
          showDialog<void>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  'Выберите основной цвет приложения',
                  style: theme.appBarTheme.titleTextStyle,
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
                    child: Text('Отмена', style: theme.textTheme.bodyLarge),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      appColorController.load();
                    },
                    child: Text('Применить', style: theme.textTheme.bodyLarge),
                  ),
                ],
              );
            },
          );
        },
        icon: const Icon(Icons.navigate_next),
      ),
    );
  }
}
