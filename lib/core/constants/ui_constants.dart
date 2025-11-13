import '../theme/app_design_tokens.dart';

/// Feature-specific UI constants that build on top of design tokens
/// All values should reference AppDesignTokens for consistency

class CardConstants {
  CardConstants._();

  static const double elevation = AppDesignTokens.cardElevation;
  static const double backgroundOpacity = AppDesignTokens.opacityMediumLight;
  static const double errorIconSize = AppDesignTokens.iconSizeXLargeBase;
  static const double gradientOpacity = 0.55;
  static const double defaultGradientOpacity =
      AppDesignTokens.opacityMediumLight;
  static const double imagePositionLeft = 0.02;
  static const double imagePositionBottom = -0.002;
  static const double idBadgePositionRight = 0.04;
  static const double heartIconTop = 0.02;
  static const double heartIconRight = 0.02;
}

class IdBadgeConstants {
  IdBadgeConstants._();

  static const int idPadLength = 3;
  static const double opacityNormal = AppDesignTokens.opacityMedium;
  static const double opacityLarge = 0.12;
  static const double shadowOpacityLarge = AppDesignTokens.opacityNormal;
  static const double shadowOffsetSizeX = AppDesignTokens.spacingXS;
  static const double shadowOffsetSizeY = 2.0;
}

class NameConstants {
  NameConstants._();

  static const double spacing = AppDesignTokens.spacingXS;
}

class TypeBadgeConstants {
  TypeBadgeConstants._();

  static const double iconPadding = 4.8;
  static const double spacing = AppDesignTokens.spacingXS;
}

class ListPageConstants {
  ListPageConstants._();

  static const double scrollThreshold = AppDesignTokens.scrollThreshold;
  static const int snackBarDuration = AppDesignTokens.snackBarDurationMs;
  static const int refreshDelayDuration = AppDesignTokens.refreshDelayMs;
  static const double errorIconSize = AppDesignTokens.iconSizeXXLargeBase;
  static const double errorSpacing = AppDesignTokens.spacingL;
  static const double emptyStateTextSize = AppDesignTokens.fontSizeLarge;
  static const double errorTextSize = AppDesignTokens.fontSizeMedium;
  static const double listHorizontalPadding = AppDesignTokens.spacingS;
  static const double listVerticalPadding = 2.0;
  static const double listItemVerticalPadding = 2.0;
  static const double loadingIndicatorPadding = AppDesignTokens.fontSizeLarge;
}

class SearchBarConstants {
  SearchBarConstants._();

  static double get height => AppDesignTokens.searchBarHeight;
  static double get borderRadius => AppDesignTokens.borderRadius;
  static double get iconSize => AppDesignTokens.iconSize * 1.4;
  static const double horizontalPadding = AppDesignTokens.spacingL;
  static const double iconPadding = AppDesignTokens.spacingS;
  static const double fontSize = AppDesignTokens.fontSizeMedium;
  static const double marginHorizontal = AppDesignTokens.spacingL;
  static const double marginVertical = AppDesignTokens.spacingS;
}

class AppBarConstants {
  AppBarConstants._();

  static double get preferredHeight => AppDesignTokens.appBarHeight;
  static double get toolbarHeight =>
      AppDesignTokens.buttonHeight + AppDesignTokens.spacingXL;
  static double get actionButtonSize => AppDesignTokens.buttonHeight;
  static double get actionButtonIconSize => AppDesignTokens.iconSize;
  static const double elevation = AppDesignTokens.appBarElevation;
}
