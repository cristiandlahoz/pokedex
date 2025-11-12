import 'package:flutter/material.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../utils/pokemon_type_colors.dart';
import '../../../domain/entities/pokemon_details.dart';
import '../../../domain/entities/pokemon_types.dart';

class SpeciesSection extends StatelessWidget {
  final PokemonDetails pokemon;

  const SpeciesSection({
    super.key,
    required this.pokemon,
  });

  Color _getPrimaryTypeColor() {
    final primaryType = pokemon.types.isNotEmpty
        ? pokemon.types.first.name
        : 'normal';
    return PokemonTypeColors.getColor(primaryType);
  }

  @override
  Widget build(BuildContext context) {
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
              'Species',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _getPrimaryTypeColor(),
              ),
            ),
          ),
          if (pokemon.genus != null) ...[
            const SizedBox(height: 16),
            Text(
              pokemon.genus!,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
          if (pokemon.description != null) ...[
            const SizedBox(height: 12),
            Text(
              pokemon.description!.replaceAll('\n', ' ').replaceAll('\f', ' '),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: pokemon.types.map((type) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: PokemonTypeColors.getColor(type.name),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  type.displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
