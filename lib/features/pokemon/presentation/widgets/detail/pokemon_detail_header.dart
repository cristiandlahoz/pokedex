import 'package:flutter/material.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../utils/pokemon_type_colors.dart';
import '../../../domain/entities/pokemon_details.dart';
import '../shared/type_badge.dart';

class PokemonDetailHeader extends StatelessWidget {
  final PokemonDetails pokemon;

  const PokemonDetailHeader({
    super.key,
    required this.pokemon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNameAndId(),
          const SizedBox(height: AppConstants.smallPadding),
        ],
      ),
    );
  }

  Widget _buildNameAndId() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            pokemon.displayName,
            style: const TextStyle(
              fontSize: AppConstants.fontSizeHeader,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          '#${pokemon.id.toString().padLeft(3, '0')}',
          style: TextStyle(
            fontSize: AppConstants.fontSizeHuge,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade400,
          ),
        ),
      ],
    );
  }
}
