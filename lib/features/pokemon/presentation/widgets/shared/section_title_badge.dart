import 'package:flutter/material.dart';
import '../../../../../core/theme/tokens.dart';

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
        horizontal: DesignTokens.spacingL,
        vertical: DesignTokens.spacingS,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: DesignTokens.opacityMediumLight),
        borderRadius: BorderRadius.circular(DesignTokens.radiusXLBase),
        border: Border.all(
          color: color,
          width: DesignTokens.borderWidthMedium,
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: DesignTokens.fontSizeBody,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
