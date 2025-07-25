import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shmr_finance_app/core/theme/dark_theme.dart';
import 'package:shmr_finance_app/core/theme/light_theme.dart';
import 'package:shmr_finance_app/data/sources/app_color/app_color_datasource.dart';
import 'package:shmr_finance_app/domain/controllers/app_color/app_color_controller.dart';
import 'package:shmr_finance_app/l10n/app_localizations.dart';

class TestAppWrapper extends StatelessWidget {
  const TestAppWrapper({
    required this.child,
    this.isDarkTheme = false,
    this.locale = const Locale('en'),
    this.primaryColor,
    super.key,
  });

  final Widget child;
  final bool isDarkTheme;
  final Locale locale;
  final Color? primaryColor;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: _initializePreferences(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            home: Material(
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          );
        }

        final preferences = snapshot.data!;
        final appColorDatasource = AppColorDatasource(preferences: preferences);
        final appColorController = AppColorController(
          appColorDatasource: appColorDatasource,
        );

        if (primaryColor != null) {
          appColorController.setPrimaryColor(primaryColor!);
        }

        return ChangeNotifierProvider<AppColorController>.value(
          value: appColorController,
          child: Builder(
            builder: (context) {
              final theme = isDarkTheme
                  ? getDarkTheme(context)
                  : getLightTheme(context);

              return MaterialApp(
                theme: theme,
                locale: locale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [Locale('en'), Locale('ru')],
                home: Material(
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: child,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<SharedPreferences> _initializePreferences() async {
    SharedPreferences.setMockInitialValues({
      if (primaryColor != null)
        'app_primary_color': primaryColor!
            .toARGB32()
            .toRadixString(16)
            .substring(2)
            .toUpperCase(),
    });
    return SharedPreferences.getInstance();
  }
}

class TestAppWrapperFactory {
  static TestAppWrapper lightEnglish({required Widget child}) {
    return TestAppWrapper(
      isDarkTheme: false,
      locale: const Locale('en'),
      child: child,
    );
  }

  static TestAppWrapper darkEnglish({required Widget child}) {
    return TestAppWrapper(
      isDarkTheme: true,
      locale: const Locale('en'),
      child: child,
    );
  }
}
