import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

class TypeBadge extends StatelessWidget {
  final String typeName;
  final Color color;

  const TypeBadge({
    super.key,
    required this.typeName,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.mediumPadding,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppConstants.extraLargeBorderRadius),
      ),
      child: Text(
        typeName.toUpperCase(),
        style: const TextStyle(
          fontSize: AppConstants.fontSizeRegular,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
