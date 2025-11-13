import 'package:flutter/material.dart';

/// Semantic color system for the application
/// Provides consistent colors across all features
class AppColors {
  AppColors._();

  // ==================== PRIMARY COLORS ====================
  static const Color primary = Color(0xFFDC2626);
  static const Color primaryLight = Color(0xFFEF4444);
  static const Color primaryDark = Color(0xFFB91C1C);

  // ==================== SURFACE COLORS ====================
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF5F5F5);
  static const Color background = Colors.white;
  static const Color backgroundGrey = Color(0xFFF9FAFB);

  // ==================== TEXT COLORS ====================
  static const Color textPrimary = Colors.black87;
  static const Color textSecondary = Color(0xFF757575);
  static const Color textTertiary = Color(0xFF9E9E9E);
  static const Color textDisabled = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Colors.white;

  // ==================== UI ELEMENT COLORS ====================
  static const Color searchBarBackground = Color(0xFFF2F2F2);
  static const Color hintTextColor = Color(0xFF757575);
  static const Color iconColor = Colors.black87;
  static const Color iconDisabled = Color(0xFFBDBDBD);

  // ==================== BORDER & DIVIDER ====================
  static const Color divider = Color(0xFFE0E0E0);
  static const Color border = Color(0xFFE0E0E0);
  static const Color cardBorder = Color(0xFFE0E0E0);
  static const Color borderLight = Color(0xFFEEEEEE);

  // ==================== STATUS COLORS ====================
  static const Color error = Colors.red;
  static const Color errorLight = Color(0xFFFFEBEE);
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFF3E0);
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFFE3F2FD);

  // ==================== NEUTRAL GRAYS ====================
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // ==================== SEMANTIC ALIASES ====================
  static const Color sectionBackground = grey50;
  static const Color cardBackground = surface;
  static const Color modalBackground = surface;
  static const Color overlayBackground = Colors.black54;

  // ==================== SHADOW COLORS ====================
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);
  static const Color shadowDark = Color(0x4D000000);
}
