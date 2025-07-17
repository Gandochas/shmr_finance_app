import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shmr_finance_app/domain/controllers/app_color_controller.dart';

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
                title: const Text('Выберите основной цвет приложения'),
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
    );
  }
}
