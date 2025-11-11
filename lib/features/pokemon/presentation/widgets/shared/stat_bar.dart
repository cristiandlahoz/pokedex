import 'package:flutter/material.dart';
import '../../../../../core/constants/app_constants.dart';

class StatBar extends StatelessWidget {
  final String name;
  final int value;
  final Color color;
  final int maxValue;

  const StatBar({
    super.key,
    required this.name,
    required this.value,
    required this.color,
    this.maxValue = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      child: Row(
        children: [
          _buildStatName(),
          _buildProgressBar(),
          const SizedBox(width: AppConstants.smallPadding),
          _buildStatValue(),
        ],
      ),
    );
  }

  Widget _buildStatName() {
    return SizedBox(
      width: AppConstants.statNameWidth,
      child: Text(
        name,
        style: TextStyle(
          fontSize: AppConstants.fontSizeRegular,
          fontWeight: FontWeight.w500,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Expanded(
      child: Stack(
        children: [
          Container(
            height: AppConstants.statBarHeight,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
            ),
          ),
          FractionallySizedBox(
            widthFactor: (value / maxValue).clamp(0.0, 1.0),
            child: Container(
              height: AppConstants.statBarHeight,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatValue() {
    return SizedBox(
      width: AppConstants.statValueWidth,
      child: Text(
        value.toString(),
        style: const TextStyle(
          fontSize: AppConstants.fontSizeRegular,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.right,
      ),
    );
  }
}
