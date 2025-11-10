import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/pokemon_type_colors.dart';
import '../../domain/entities/pokemon.dart';

class BreedingSection extends StatelessWidget {
  final Pokemon pokemon;

  const BreedingSection({
    super.key,
    required this.pokemon,
  });

  Color _getPrimaryTypeColor() {
    final primaryType = pokemon.types.isNotEmpty
        ? pokemon.types.first.name
        : 'normal';
    return PokemonTypeColors.getColor(primaryType);
  }


  String _formatEggGroupName(String name) {
    if (name.contains('-')) {
      return name.split('-').map((word) {
        return word[0].toUpperCase() + word.substring(1);
      }).join(' ');
    }
    return name[0].toUpperCase() + name.substring(1);
  }

  Color _getEggGroupColor(int index) {
    final colors = [
      Colors.purple.shade100,
      Colors.pink.shade100,
      Colors.blue.shade100,
      Colors.green.shade100,
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    if (pokemon.eggGroups == null || pokemon.eggGroups!.isEmpty) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
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
                'Breeding',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _getPrimaryTypeColor(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Egg groups:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: pokemon.eggGroups!.asMap().entries.map((entry) {
              final index = entry.key;
              final eggGroup = entry.value;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: _getEggGroupColor(index),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatEggGroupName(eggGroup),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _getEggGroupColor(index).computeLuminance() > 0.5
                            ? Colors.purple.shade700
                            : Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: _getEggGroupColor(index).computeLuminance() > 0.5
                          ? Colors.purple.shade700
                          : Colors.white,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          if (pokemon.hatchCounter != null) ...[
            const SizedBox(height: 20),
            const Text(
              'Egg cycles:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${pokemon.hatchCounter} ',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextSpan(
                    text: '(${(pokemon.hatchCounter! + 1) * 255} Steps)',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
