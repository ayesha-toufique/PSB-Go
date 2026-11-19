
import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class AppThemes {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackgroundStart,
    primaryColor: AppColors.brandGreen,
    fontFamily: 'Roboto',

    colorScheme: const ColorScheme.light(
      primary: AppColors.brandGreen,
      secondary: AppColors.brandTeal,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightPrimaryText,
      onPrimary: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBackgroundStart,
      foregroundColor: AppColors.lightPrimaryText,
      elevation: 0,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightSurface,
      hintStyle: const TextStyle(
        color: AppColors.lightSecondaryText,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.lightBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppColors.brandTeal,
          width: 1.5,
        ),
      ),
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.lightPrimaryText),
      bodyMedium: TextStyle(color: AppColors.lightSecondaryText),
      titleLarge: TextStyle(
        color: AppColors.lightPrimaryText,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackgroundStart,
    primaryColor: AppColors.brandCyan,
    fontFamily: 'Roboto',

    colorScheme: const ColorScheme.dark(
      primary: AppColors.brandGreen,
      secondary: AppColors.brandCyan,
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkPrimaryText,
      onPrimary: Colors.black,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackgroundStart,
      foregroundColor: AppColors.darkPrimaryText,
      elevation: 0,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurface,
      hintStyle: const TextStyle(
        color: AppColors.darkSecondaryText,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: AppColors.brandCyan,
          width: 1.5,
        ),
      ),
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.darkPrimaryText),
      bodyMedium: TextStyle(color: AppColors.darkSecondaryText),
      titleLarge: TextStyle(
        color: AppColors.darkPrimaryText,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
