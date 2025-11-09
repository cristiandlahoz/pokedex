import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import 'info_placeholder.dart';

class EvolutionSection extends StatelessWidget {
  const EvolutionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Evolution Chain',
            style: TextStyle(
              fontSize: AppConstants.fontSizeTitle,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppConstants.mediumPadding),
          InfoPlaceholder(message: 'Evolution data coming soon'),
        ],
      ),
    );
  }
}
