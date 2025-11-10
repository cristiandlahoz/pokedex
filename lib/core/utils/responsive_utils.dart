import 'package:flutter/material.dart';

class ResponsiveUtils {
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getWidthPercentage(BuildContext context, double percentage) {
    return getScreenWidth(context) * percentage;
  }

  static double getHeightPercentage(BuildContext context, double percentage) {
    return getScreenHeight(context) * percentage;
  }

  static double getCardHeight(BuildContext context) {
    return getHeightPercentage(context, 0.14);
  }

  static double getCardImageSize(BuildContext context) {
    return getHeightPercentage(context, 0.12);
  }

  static double getTypeBadgeSize(BuildContext context) {
    return getHeightPercentage(context, 0.025);
  }

  static double getPokemonIdBadgeSize(BuildContext context) {
    return getWidthPercentage(context, 0.16);
  }

  static double getCardPadding(BuildContext context) {
    return getWidthPercentage(context, 0.02);
  }

  static double getCardBorderRadius(BuildContext context) {
    return getWidthPercentage(context, 0.05);
  }

  static double getSpacingSmall(BuildContext context) {
    return getWidthPercentage(context, 0.015);
  }

  static double getSpacingMedium(BuildContext context) {
    return getWidthPercentage(context, 0.03);
  }

  static double getFontSizeSmall(BuildContext context) {
    return getWidthPercentage(context, 0.03);
  }

  static double getFontSizeMedium(BuildContext context) {
    return getWidthPercentage(context, 0.04);
  }

  static double getFontSizeLarge(BuildContext context) {
    return getWidthPercentage(context, 0.05);
  }

  static double getFontSizeExtraLarge(BuildContext context) {
    return getWidthPercentage(context, 0.135);
  }
}
