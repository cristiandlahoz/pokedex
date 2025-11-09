import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/pokemon.dart';
import 'physical_stat_card.dart';

class PhysicalStatsSection extends StatelessWidget {
  final Pokemon pokemon;

  const PhysicalStatsSection({
    super.key,
    required this.pokemon,
  });

  String _formatHeight(int? height) {
    if (height == null) return 'N/A';
    return '${(height / 10).toStringAsFixed(1)} m';
  }

  String _formatWeight(int? weight) {
    if (weight == null) return 'N/A';
    return '${(weight / 10).toStringAsFixed(1)} kg';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
      child: Row(
        children: [
          Expanded(
            child: PhysicalStatCard(
              label: 'Height',
              value: _formatHeight(pokemon.height),
              icon: Icons.height,
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: AppConstants.smallPadding),
          Expanded(
            child: PhysicalStatCard(
              label: 'Weight',
              value: _formatWeight(pokemon.weight),
              icon: Icons.monitor_weight,
              color: Colors.orange,
            ),
          ),
          const SizedBox(width: AppConstants.smallPadding),
          Expanded(
            child: PhysicalStatCard(
              label: 'Base EXP',
              value: pokemon.baseExperience?.toString() ?? 'N/A',
              icon: Icons.star,
              color: Colors.amber,
            ),
          ),
        ],
      ),
    );
  }
}
