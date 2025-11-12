import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_design_tokens.dart';

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
        size: AppDesignTokens.iconSizeLarge,
      ),
      titleTextStyle: TextStyle(
        fontSize: AppDesignTokens.fontSizeXXLarge,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
        letterSpacing: -0.5,
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        iconSize: WidgetStateProperty.all(AppDesignTokens.iconSize),
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
        horizontal: AppDesignTokens.spacingL,
        vertical: 0,
      ),
      isDense: true,
    ),
  );
}
