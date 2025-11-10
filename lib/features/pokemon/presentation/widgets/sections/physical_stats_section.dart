import 'package:flutter/material.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../domain/entities/pokemon.dart';
import '../shared/physical_stat_card.dart';

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

  String _formatGenderRatio(int? genderRate) {
    if (genderRate == null) return 'Unknown';
    if (genderRate == -1) return 'Genderless';
    
    final femalePercent = (genderRate / 8 * 100).toStringAsFixed(1);
    final malePercent = ((8 - genderRate) / 8 * 100).toStringAsFixed(1);
    return '$malePercent%  $femalePercent%';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.defaultPadding),
      child: Column(
        children: [
          Row(
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
            ],
          ),
          if (pokemon.genderRate != null) ...[
            const SizedBox(height: AppConstants.smallPadding),
            PhysicalStatCard(
              label: 'Gender Ratio',
              value: _formatGenderRatio(pokemon.genderRate),
              icon: pokemon.genderRate == -1 ? Icons.block : Icons.wc,
              color: pokemon.genderRate == -1 ? Colors.grey : Colors.purple,
            ),
          ],
        ],
      ),
    );
  }
}
