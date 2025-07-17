import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shmr_finance_app/core/widgets/settings_widgets/main_tint_picker_widget.dart';
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
              ListTile(
                title: Text('Системная тема', style: theme.textTheme.bodyLarge),
                trailing: Switch.adaptive(value: false, onChanged: (value) {}),
              ),
              Divider(height: 1, color: theme.dividerColor),
              MainTintPickerWidget(appColorController: appColorController),
              Divider(height: 1, color: theme.dividerColor),
              ListTile(
                title: Text('Хаптики', style: theme.textTheme.bodyLarge),
                trailing: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.navigate_next),
                ),
              ),
              Divider(height: 1, color: theme.dividerColor),
              ListTile(
                title: Text('Код пароль', style: theme.textTheme.bodyLarge),
                trailing: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.navigate_next),
                ),
              ),
              Divider(height: 1, color: theme.dividerColor),
              ListTile(
                title: Text('Язык', style: theme.textTheme.bodyLarge),
                trailing: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.navigate_next),
                ),
              ),
              Divider(height: 1, color: theme.dividerColor),
            ],
          ),
        );
      },
    );
  }
}
