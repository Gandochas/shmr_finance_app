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
      secondary: kHighlightColor,
      surface: kSurfaceColor,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: kTextPrimaryColor,
    ),
    appBarTheme: const AppBarTheme(
      color: kPrimaryColor,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
        fontSize: 22,
        height: 28 / 22,
        letterSpacing: 0,
        color: kTextPrimaryColor,
      ),
      iconTheme: IconThemeData(color: kTextPrimaryColor),
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
}
