import 'package:flutter/material.dart';
import 'package:shmr_finance_app/core/widgets/settings_widgets/biometric_auth_switch.dart';
import 'package:shmr_finance_app/core/widgets/settings_widgets/haptic_touch_switch.dart';
import 'package:shmr_finance_app/core/widgets/settings_widgets/localization_changer.dart';
import 'package:shmr_finance_app/core/widgets/settings_widgets/main_tint_picker_widget.dart';
import 'package:shmr_finance_app/core/widgets/settings_widgets/pin_code_changer.dart';
import 'package:shmr_finance_app/core/widgets/settings_widgets/system_theme_switch.dart';
import 'package:shmr_finance_app/l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Text(
          localization.settings,
          style: theme.appBarTheme.titleTextStyle,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SystemThemeSwitch(),
          Divider(height: 1, color: theme.dividerColor),
          const MainTintPickerWidget(),
          Divider(height: 1, color: theme.dividerColor),
          const HapticTouchSwitch(),
          Divider(height: 1, color: theme.dividerColor),
          const PinCodeChanger(),
          Divider(height: 1, color: theme.dividerColor),
          const BiometricAuthSwitch(),
          Divider(height: 1, color: theme.dividerColor),
          const LocalizationChanger(),
          Divider(height: 1, color: theme.dividerColor),
        ],
      ),
    );
  }
}
