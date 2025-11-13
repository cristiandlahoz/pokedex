import 'package:flutter/material.dart';
import '../../../../../core/theme/app_design_tokens.dart';

/// Reusable section title badge with consistent styling
/// Used across all detail section widgets
class SectionTitleBadge extends StatelessWidget {
  final String title;
  final Color color;

  const SectionTitleBadge({
    super.key,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDesignTokens.spacingL,
        vertical: AppDesignTokens.spacingS,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: AppDesignTokens.opacityMediumLight),
        borderRadius: BorderRadius.circular(AppDesignTokens.radiusXLBase),
        border: Border.all(
          color: color,
          width: AppDesignTokens.borderWidthMedium,
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: AppDesignTokens.fontSizeBody,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
