/// Unified Design Token System
/// Single source of truth for all spacing, sizing, and styling values
class AppDesignTokens {
  AppDesignTokens._();

  // ==================== BASE UNITS ====================
  static const double baseUnit = 8.0;
  static const double densityMultiplier = 0.85;

  static double unit(double multiplier) =>
      baseUnit * multiplier * densityMultiplier;

  // ==================== SPACING ====================
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 12.0;
  static const double spacingL = 16.0;
  static const double spacingXL = 20.0;
  static const double spacingXXL = 24.0;
  static const double spacingXXXL = 32.0;

  // Legacy aliases for backward compatibility
  static const double smallPadding = spacingM; // 12.0
  static const double mediumPadding = spacingL; // 16.0
  static const double defaultPadding = spacingXXL; // 24.0
  static const double largePadding = spacingXXXL; // 32.0

  // ==================== BORDER RADIUS ====================
  static const double radiusXSBase = 6.0;
  static const double radiusSBase = 8.0;
  static const double radiusMBase = 12.0;
  static const double radiusLBase = 16.0;
  static const double radiusXLBase = 20.0;
  static const double radiusXXLBase = 24.0;
  static const double radiusXXXLBase = 30.0;

  static double get radiusXS => radiusXSBase * densityMultiplier;
  static double get radiusS => radiusSBase * densityMultiplier;
  static double get radiusM => radiusMBase * densityMultiplier;
  static double get radiusL => radiusLBase * densityMultiplier;
  static double get radiusXL => radiusXLBase * densityMultiplier;
  static double get radiusXXL => radiusXXLBase * densityMultiplier;
  static double get radiusXXXL => radiusXXXLBase * densityMultiplier;

  // Legacy aliases
  static double get borderRadius => radiusXXL; // 24.0 * density
  static const double defaultBorderRadius = radiusMBase; // 12.0
  static const double largeBorderRadius = radiusLBase; // 16.0
  static const double extraLargeBorderRadius = radiusXLBase; // 20.0
  static const double detailsTopBorderRadius = radiusXXXLBase; // 30.0

  // ==================== ICON SIZES ====================
  static const double iconSizeSmallBase = 16.0;
  static const double iconSizeMediumBase = 20.0;
  static const double iconSizeBase = 24.0;
  static const double iconSizeLargeBase = 28.0;
  static const double iconSizeXLargeBase = 48.0;
  static const double iconSizeXXLargeBase = 64.0;
  static const double iconSizeHugeBase = 100.0;
  static const double iconSizeGiantBase = 200.0;

  static double get iconSizeSmall => iconSizeSmallBase * densityMultiplier;
  static double get iconSizeMedium => iconSizeMediumBase * densityMultiplier;
  static double get iconSize => iconSizeBase * densityMultiplier;
  static double get iconSizeLarge => iconSizeLargeBase * densityMultiplier;
  static double get iconSizeXLarge => iconSizeXLargeBase * densityMultiplier;
  static double get iconSizeXXLarge => iconSizeXXLargeBase * densityMultiplier;
  static double get iconSizeHuge => iconSizeHugeBase * densityMultiplier;
  static double get iconSizeGiant => iconSizeGiantBase * densityMultiplier;

  // ==================== FONT SIZES ====================
  static const double fontSizeXS = 10.0;
  static const double fontSizeSmall = 12.0;
  static const double fontSizeBody = 14.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 18.0;
  static const double fontSizeXLarge = 20.0;
  static const double fontSizeXXLarge = 24.0;
  static const double fontSizeXXXLarge = 32.0;

  // Legacy aliases
  static const double fontSizeRegular = fontSizeBody; // 14.0
  static const double fontSizeTitle = 22.0;
  static const double fontSizeHuge = fontSizeXXLarge; // 24.0
  static const double fontSizeHeader = fontSizeXXXLarge; // 32.0

  // ==================== OPACITY ====================
  static const double opacityDisabled = 0.38;
  static const double opacityLight = 0.1;
  static const double opacityMediumLight = 0.2;
  static const double opacityBorder = 0.3;
  static const double opacityNormal = 0.5;
  static const double opacityMedium = 0.6;
  static const double opacityMediumHigh = 0.7;
  static const double opacityText = 0.8;

  // ==================== COMPONENT SIZES ====================
  // Buttons
  static const double buttonHeightBase = 48.0;
  static double get buttonHeight => buttonHeightBase * densityMultiplier;

  // Search Bar
  static const double searchBarHeightBase = 48.0;
  static double get searchBarHeight => searchBarHeightBase * densityMultiplier;

  // App Bar
  static const double appBarHeightBase = 120.0;
  static double get appBarHeight => appBarHeightBase * densityMultiplier;
  static const double appBarExpandedHeight = 300.0;
  static const double appBarElevation = 8.0;

  // Stats
  static const double statBarHeight = 12.0;
  static const double statNameWidth = 80.0;
  static const double statValueWidth = 40.0;

  // Images
  static const double imageHeight = 200.0;

  // Cards
  static const double cardElevation = 5.0;

  // ==================== ANIMATION DURATIONS ====================
  static const int animationDurationMs = 600;
  static const int pageTransitionDurationMs = 300;
  static const int snackBarDurationMs = 500;
  static const int refreshDelayMs = 500;
  static const int searchDebounceMs = 500;

  // ==================== BORDER WIDTHS ====================
  static const double borderWidthThin = 1.0;
  static const double borderWidthMedium = 1.5;
  static const double borderWidthThick = 2.0;
  static const double borderWidthBold = 3.0;

  // ==================== PAGINATION ====================
  static const int defaultPageSize = 20;
  static const int defaultMovesLimit = 20;

  // ==================== SCROLL ====================
  static const double scrollThreshold = 0.9;

  // ==================== CHIP ====================
  static const double chipHorizontalPadding = spacingS;
  static const double chipVerticalPadding = spacingXS;
  static const double chipBorderRadius = radiusXSBase;
  static const double chipSpacing = spacingS;
  static const double chipRunSpacing = spacingXS;
}
