import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../data/dtos/parsers/evolution_parser.dart';
import '../../../domain/entities/evolution_species.dart';
import '../../../domain/entities/pokemon.dart';
import '../../constants/evolution.dart';
import '../../utils/navigation.dart';
import '../shared/type_badge.dart';

class EvolutionSpeciesCard extends StatelessWidget {
  final EvolutionSpecies species;
  final bool isCurrentPokemon;

  const EvolutionSpeciesCard({
    super.key,
    required this.species,
    this.isCurrentPokemon = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: species.pokemonId != null
          ? () => Navigation.navigateToDetails(
              context: context,
              pokemon: Pokemon(
                id: species.pokemonId!,
                name: species.pokemonName ?? species.speciesName,
                types: species.types,
                imageUrl: species.imageUrl,
              ),
            )
          : null,
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(EvolutionConstants.cardPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: isCurrentPokemon
              ? Border.all(
                  color: EvolutionConstants.selectedBorderColor,
                  width: EvolutionConstants.selectedBorderWidth,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSprite(),
            const SizedBox(height: EvolutionConstants.textSpacing),
            _buildTypeBadges(),
            const SizedBox(height: EvolutionConstants.textSpacing),
            _buildName(),
            if (species.hasEvolutionRequirements) ...[
              const SizedBox(height: EvolutionConstants.textSpacing),
              _buildRequirements(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSprite() {
    if (species.imageUrl == null) {
      return Container(
        width: EvolutionConstants.spriteSizeLarge,
        height: EvolutionConstants.spriteSizeLarge,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.question_mark, color: Colors.grey),
      );
    }

    return CachedNetworkImage(
      imageUrl: species.imageUrl!,
      width: EvolutionConstants.spriteSizeLarge,
      height: EvolutionConstants.spriteSizeLarge,
      placeholder: (context, url) => Container(
        width: EvolutionConstants.spriteSizeLarge,
        height: EvolutionConstants.spriteSizeLarge,
        color: Colors.grey[200],
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  Widget _buildTypeBadges() {
    if (species.types.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: species.types.take(2).map((type) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: TypeBadge(type: type),
        );
      }).toList(),
    );
  }

  Widget _buildName() {
    return Text(
      species.displayName,
      style: const TextStyle(
        fontSize: EvolutionConstants.nameTextSize,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildRequirements() {
    final descriptions = species.requirements
        .map((req) => EvolutionParser.formatRequirementDescription(req))
        .toList();

    final combinedText = descriptions.join('\nOR ');

    return Text(
      combinedText,
      style: const TextStyle(
        fontSize: EvolutionConstants.requirementTextSize,
        color: Colors.black54,
      ),
      textAlign: TextAlign.center,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }
}
