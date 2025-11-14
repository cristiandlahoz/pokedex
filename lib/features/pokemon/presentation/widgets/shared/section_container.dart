import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/tokens.dart';

/// Reusable container for detail sections
/// Provides consistent styling across all section widgets
class SectionContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;

  const SectionContainer({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(DesignTokens.spacingL),
    this.margin = const EdgeInsets.only(bottom: DesignTokens.spacingL),
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.sectionBackground,
        borderRadius:
            BorderRadius.circular(DesignTokens.defaultBorderRadius),
      ),
      child: child,
    );
  }
}
