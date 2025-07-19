import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:shmr_finance_app/domain/controllers/app_color/app_color_controller.dart';
import 'package:shmr_finance_app/l10n/app_localizations.dart';

class MainTintPickerWidget extends StatelessWidget {
  const MainTintPickerWidget({required this.appColorController, super.key});

  final AppColorController appColorController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return ListTile(
      title: Text(localization.main_color, style: theme.textTheme.bodyLarge),
      trailing: IconButton(
        onPressed: () {
          showDialog<void>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  localization.choose_main_color,
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
                    child: Text(
                      localization.cancel,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      appColorController.load();
                    },
                    child: Text(
                      localization.apply,
                      style: theme.textTheme.bodyLarge,
                    ),
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
