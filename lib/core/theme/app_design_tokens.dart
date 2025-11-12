class AppDesignTokens {
  AppDesignTokens._();

  static const double densityMultiplier = 0.85;

  static const double baseUnit = 8.0;

  static double unit(double multiplier) => baseUnit * multiplier * densityMultiplier;

  static const double buttonHeightBase = 48.0;
  static double get buttonHeight => buttonHeightBase * densityMultiplier;

  static const double searchBarHeightBase = 48.0;
  static double get searchBarHeight => searchBarHeightBase * densityMultiplier;

  static const double iconSizeBase = 24.0;
  static double get iconSize => iconSizeBase * densityMultiplier;

  static const double iconSizeLargeBase = 28.0;
  static double get iconSizeLarge => iconSizeLargeBase * densityMultiplier;

  static const double iconSizeMediumBase = 20.0;
  static double get iconSizeMedium => iconSizeMediumBase * densityMultiplier;

  static const double iconSizeSmallBase = 16.0;
  static double get iconSizeSmall => iconSizeSmallBase * densityMultiplier;

  static const double borderRadiusBase = 24.0;
  static double get borderRadius => borderRadiusBase * densityMultiplier;

  static const double radiusLBase = 16.0;
  static double get radiusL => radiusLBase * densityMultiplier;

  static const double radiusMBase = 12.0;
  static double get radiusM => radiusMBase * densityMultiplier;

  static const double radiusSBase = 8.0;
  static double get radiusS => radiusSBase * densityMultiplier;

  static const double appBarHeightBase = 120.0;
  static double get appBarHeight => appBarHeightBase * densityMultiplier;

  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 12.0;
  static const double spacingL = 16.0;
  static const double spacingXL = 20.0;
  static const double spacingXXL = 24.0;

  static const double fontSizeSmall = 12.0;
  static const double fontSizeBody = 14.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 20.0;
  static const double fontSizeXLarge = 24.0;
  static const double fontSizeXXLarge = 32.0;
}
