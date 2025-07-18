import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shmr_finance_app/core/widgets/settings_widgets/main_tint_picker_widget.dart';
import 'package:shmr_finance_app/core/widgets/settings_widgets/system_theme_switch.dart';
import 'package:shmr_finance_app/domain/controllers/app_color/app_color_controller.dart';
import 'package:shmr_finance_app/domain/controllers/app_theme/app_theme_controller.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<AppColorController, AppThemeController>(
      builder: (context, appColorController, appThemeController, child) {
        final theme = Theme.of(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: theme.appBarTheme.backgroundColor,
            title: Text('Настройки', style: theme.appBarTheme.titleTextStyle),
            centerTitle: true,
          ),
          body: Column(
            children: [
              SystemThemeSwitch(appThemeController: appThemeController),
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
