import '../../../../core/theme/tokens.dart';

/// Pokemon list app bar constants
class AppBarConstants {
  AppBarConstants._();

  static double get preferredHeight => DesignTokens.appBarHeight;
  static double get toolbarHeight => DesignTokens.buttonHeight + DesignTokens.spacingXL;
  static double get actionButtonSize => DesignTokens.buttonHeight;
  static double get actionButtonIconSize => DesignTokens.iconSize;
  static const double elevation = DesignTokens.appBarElevation;
}
