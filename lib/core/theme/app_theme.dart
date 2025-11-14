import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'tokens.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      surface: AppColors.surface,
      error: AppColors.error,
    ),
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.surface,
      elevation: 0,
      iconTheme: IconThemeData(
        color: AppColors.iconColor,
        size: DesignTokens.iconSizeLarge,
      ),
      titleTextStyle: TextStyle(
        fontSize: DesignTokens.fontSizeXXLarge,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
        letterSpacing: -0.5,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconSize: WidgetStateProperty.all(DesignTokens.iconSize),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      hintStyle: const TextStyle(
        color: AppColors.hintTextColor,
        fontWeight: FontWeight.w400,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: DesignTokens.spacingL,
        vertical: 0,
      ),
      isDense: true,
    ),
  );
}
