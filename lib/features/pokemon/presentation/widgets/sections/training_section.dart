import 'package:flutter/material.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../utils/pokemon_type_colors.dart';
import '../../../domain/entities/pokemon.dart';

class TrainingSection extends StatelessWidget {
  final Pokemon pokemon;

  const TrainingSection({
    super.key,
    required this.pokemon,
  });

  Color _getPrimaryTypeColor() {
    final primaryType = pokemon.types.isNotEmpty
        ? pokemon.types.first.name
        : 'normal';
    return PokemonTypeColors.getColor(primaryType);
  }


  String _formatGrowthRate(String? growthRate) {
    if (growthRate == null) return 'Unknown';
    return growthRate.split('-').map((word) {
      return word[0].toUpperCase() + word.substring(1);
    }).join('-');
  }

  String _getEvYield() {
    if (pokemon.stats == null || pokemon.stats!.isEmpty) return 'Unknown';
    
    final evStats = pokemon.stats!.where((stat) => stat.effort > 0).toList();
    if (evStats.isEmpty) return 'None';
    
    return evStats.map((stat) {
      final statName = stat.name.split('-').last;
      final formattedName = statName[0].toUpperCase() + statName.substring(1);
      return '${stat.effort} $formattedName';
    }).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    if (pokemon.growthRateName == null && 
        pokemon.baseExperience == null && 
        pokemon.baseHappiness == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _getPrimaryTypeColor().withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _getPrimaryTypeColor(),
                width: 1.5,
              ),
            ),
            child: Text(
              'Training',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _getPrimaryTypeColor(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (pokemon.growthRateName != null)
            _buildInfoRow(
              label: 'Growth Rate:',
              value: _formatGrowthRate(pokemon.growthRateName),
            ),
          if (pokemon.baseExperience != null) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              label: 'Base Exp:',
              value: pokemon.baseExperience.toString(),
            ),
          ],
          if (pokemon.baseHappiness != null) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
              label: 'Base Friendship:',
              value: pokemon.baseHappiness.toString(),
            ),
          ],
          const SizedBox(height: 12),
          _buildInfoRow(
            label: 'EV Yield:',
            value: _getEvYield(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }
}
