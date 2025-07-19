import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shmr_finance_app/core/theme/app_theme.dart';
import 'package:shmr_finance_app/domain/controllers/app_color/app_color_controller.dart';

ThemeData getDarkTheme(BuildContext context) {
  final appColorController = context.watch<AppColorController>();
  final kPrimaryColor = appColorController.primaryColor;
  const kSurfaceColor = Color(0xFF303030);
  const kTextPrimaryColor = Color(0xFFE0E0E0);
  const kTextSecondaryColor = Color(0xFFB0B0B0);
  const kNavigationBarColor = Color(0xFF3D3D3D);
  final kHighlightColor = kPrimaryColor.withValues(alpha: 0.2);
  const kErrorColor = Color(0xFFE46962);
  const kSearchColor = Color(0xFF3D3D3D);

  final themeData = ThemeData(
    colorScheme: ColorScheme.dark(
      primary: kPrimaryColor,
      secondary: kHighlightColor,
      surface: kSurfaceColor,
      error: kErrorColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: kTextPrimaryColor,
      onError: Colors.white,
    ),
    searchViewTheme: const SearchViewThemeData(backgroundColor: kSearchColor),
    appBarTheme: AppBarTheme(
      color: kPrimaryColor,
      elevation: 0,
      titleTextStyle: const TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        fontSize: 22,
        height: 28 / 22,
        letterSpacing: 0,
        color: kTextPrimaryColor,
      ),
      iconTheme: const IconThemeData(color: kTextPrimaryColor),
    ),
    scaffoldBackgroundColor: kSurfaceColor,
    dividerColor: kTextSecondaryColor,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        fontSize: 16,
        height: 24 / 16,
        letterSpacing: 0.5,
        color: kTextPrimaryColor,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        fontSize: 14,
        height: 20 / 14,
        letterSpacing: 0.25,
        color: kTextSecondaryColor,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w500,
        fontSize: 12,
        height: 16 / 12,
        letterSpacing: 0.5,
        color: kTextSecondaryColor,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: kNavigationBarColor,
      indicatorColor: kHighlightColor,
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w500,
            fontSize: 12,
            height: 16 / 12,
            letterSpacing: 0.5,
            color: kTextPrimaryColor,
          );
        }
        return const TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
          fontSize: 12,
          height: 16 / 12,
          letterSpacing: 0.5,
          color: kTextSecondaryColor,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
        return IconThemeData(
          color: states.contains(WidgetState.selected)
              ? kPrimaryColor
              : kTextSecondaryColor,
        );
      }),
    ),
  );

  return themeData.copyWith(
    extensions: <ThemeExtension>[
      AppThemeColors(
        primary: kPrimaryColor,
        background: kSurfaceColor,
        surface: kSurfaceColor,
        textPrimary: kTextPrimaryColor,
        textSecondary: kTextSecondaryColor,
        navigationBarBackground: kNavigationBarColor,
        highlight: kHighlightColor,
        error: kErrorColor,
      ),
    ],
  );
}
