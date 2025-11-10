import 'package:flutter/material.dart';
import '../../../../../core/constants/app_constants.dart';

class PhysicalStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const PhysicalStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.mediumPadding),
      decoration: BoxDecoration(
        color: color.withValues(alpha: AppConstants.opacityLight),
        borderRadius: BorderRadius.circular(AppConstants.largeBorderRadius),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: AppConstants.iconSizeMedium,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: AppConstants.fontSizeExtraLarge,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: AppConstants.fontSizeSmall,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
