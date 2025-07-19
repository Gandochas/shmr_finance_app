import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shmr_finance_app/core/theme/dark_theme.dart';
import 'package:shmr_finance_app/core/theme/light_theme.dart';
import 'package:shmr_finance_app/domain/controllers/app_theme/app_theme_controller.dart';
import 'package:shmr_finance_app/domain/controllers/localization/localization_controller.dart';
import 'package:shmr_finance_app/domain/controllers/pin_code/pin_code_controller.dart';
import 'package:shmr_finance_app/domain/di/app_providers.dart';
import 'package:shmr_finance_app/l10n/app_localizations.dart';
import 'package:shmr_finance_app/presentation/main_app_blur_wrapper.dart';
import 'package:shmr_finance_app/presentation/pages/pin_code_page.dart';

class MainApp extends StatelessWidget {
  const MainApp({required this.sharedPreferences, super.key});

  final SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return AppProviders(
      sharedPreferences: sharedPreferences,
      child: Builder(
        builder: (context) {
          final appThemeController = context.watch<AppThemeController>();
          final pinCodeController = context.watch<PinCodeController>();
          final localizationController = context
              .watch<LocalizationController>();

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: appThemeController.isSystemTheme
                ? ThemeMode.system
                : ThemeMode.light,
            theme: getLightTheme(context),
            darkTheme: getDarkTheme(context),
            supportedLocales: const [Locale('en'), Locale('ru')],
            locale: Locale(localizationController.languageCode),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              AppLocalizations.delegate,
            ],
            builder: (context, child) => MainAppBlurWrapper(child: child!),
            home: pinCodeController.pinCode == null
                ? const PinCodePage(state: PinCodeState.setup)
                : const PinCodePage(state: PinCodeState.verify),
          );
        },
      ),
    );
  }
}
