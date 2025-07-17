import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shmr_finance_app/core/theme/app_theme.dart';
import 'package:shmr_finance_app/domain/controllers/app_color_controller.dart';

ThemeData getLightTheme(BuildContext context) {
  final appColorController = context.watch<AppColorController>();
  final kPrimaryColor = appColorController.primaryColor;
  // const kPrimaryColor = Color(0xFF2AE881);
  const kSurfaceColor = Color(0xFFFEF7FF);
  const kTextPrimaryColor = Color(0xFF1D1B20);
  const kTextSecondaryColor = Color(0xFF49454F);
  const kNavigationBarColor = Color(0xFFF3EDF7);
  // const kHighlightColor = Color(0xFFD4FAE6);
  final kHighlightColor = kPrimaryColor.withValues(alpha: 0.2);
  const kErrorColor = Color(0xFFE46962);
  const kSearchColor = Color(0xFFECE6F0);

  final themeData = ThemeData(
    colorScheme: ColorScheme.light(
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
