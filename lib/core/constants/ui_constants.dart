import '../theme/app_design_tokens.dart';

class PokemonCardConstants {
  PokemonCardConstants._();

  static const double cardElevation = 5.0;
  static const double backgroundOpacity = 0.2;
  static const double errorIconSize = 48.0;
  static const double gradientOpacity = 0.55;
  static const double defaultGradientOpacity = 0.2;
  static const double imagePositionLeft = 0.02;
  static const double imagePositionBottom = -0.002;
  static const double idBadgePositionRight = 0.04;
  static const double heartIconTop = 0.02;
  static const double heartIconRight = 0.02;
}

class App {
  App._();

  static const double appBarElevation = 8.0;
}

class PokemonIdBadgeConstants {
  PokemonIdBadgeConstants._();

  static const int idPadLength = 3;
  static const double opacityNormal = 0.6;
  static const double opacityLarge = 0.12;
  static const double shadowOpacityLarge = 0.5;
  static const double shadowOffsetSizeX = 4;
  static const double shadowOffsetSizeY = 2;
}

class PokemonNameConstants {
  PokemonNameConstants._();

  static const double spacing = 4.0;
}

class PokemonTypeBadgeConstants {
  PokemonTypeBadgeConstants._();

  static const double iconPadding = 4.8;
  static const double spacing = 4.0;
}

class PokemonListPageConstants {
  PokemonListPageConstants._();

  static const double scrollThreshold = 0.9;
  static const int snackBarDuration = 500;
  static const int refreshDelayDuration = 500;
  static const double errorIconSize = 64.0;
  static const double errorSpacing = 16.0;
  static const double emptyStateTextSize = 18.0;
  static const double errorTextSize = 16.0;
  static const double listHorizontalPadding = 8.0;
  static const double listVerticalPadding = 2.0;
  static const double listItemVerticalPadding = 2.0;
  static const double loadingIndicatorPadding = 18.0;
}

class PokemonSearchBarConstants {
  PokemonSearchBarConstants._();

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
  static double get toolbarHeight => AppDesignTokens.buttonHeight + AppDesignTokens.spacingXL;
  static double get actionButtonSize => AppDesignTokens.buttonHeight;
  static double get actionButtonIconSize => AppDesignTokens.iconSize;
}
