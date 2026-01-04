import 'package:flutter/material.dart';

import '../../../data/dtos/parsers/evolution_parser.dart';
import '../../../domain/entities/evolution_species.dart';
import '../../../domain/entities/pokemon.dart';
import '../../constants/evolution.dart';
import '../../utils/navigation.dart';
import '../shared/pokemon_card_base.dart';

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
    return PokemonCardBase(
      imageUrl: species.imageUrl,
      types: species.types,
      name: species.displayName,
      showBorder: isCurrentPokemon,
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
      extraContent: species.hasEvolutionRequirements
          ? _buildRequirements()
          : null,
    );
  }

  Widget _buildRequirements() {
    final descriptions = species.requirements
        .map((req) => EvolutionParser.formatRequirementDescription(req))
        .toList();

    return Text(
      descriptions.join('\nOR '),
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
