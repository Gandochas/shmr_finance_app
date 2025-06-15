import 'package:flutter/material.dart';

ThemeData getLightTheme() {
  const kPrimaryColor = Color(0xFF2AE881);
  const kSurfaceColor = Color(0xFFFEF7FF);
  const kTextPrimaryColor = Color(0xFF1D1B20);
  const kTextSecondaryColor = Color(0xFF49454F);
  const kNavigationBarColor = Color(0xFFF3EDF7);
  const kHighlightColor = Color(0xFFD4FAE6);

  return ThemeData(
    colorScheme: const ColorScheme.light(
      primary: kPrimaryColor,
      secondary: kPrimaryColor,
      surface: kSurfaceColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: kTextPrimaryColor,
    ),
    appBarTheme: const AppBarTheme(
      color: kPrimaryColor,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: kTextPrimaryColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: kTextPrimaryColor),
    ),
    scaffoldBackgroundColor: kSurfaceColor,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: kTextPrimaryColor),
      bodyMedium: TextStyle(color: kTextSecondaryColor),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: kNavigationBarColor,
      indicatorColor: kHighlightColor, // подсветка выбранного
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        return TextStyle(
          color: states.contains(WidgetState.selected)
              ? kTextPrimaryColor
              : kTextSecondaryColor,
          fontSize: 12,
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w600
              : FontWeight.w400,
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
}
