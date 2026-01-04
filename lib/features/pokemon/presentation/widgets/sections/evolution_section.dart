import 'package:flutter/material.dart';

import '../../../../../core/constants/app.dart';
import '../../../domain/entities/pokemon_details.dart';
import '../../constants/evolution.dart';
import 'evolution_chain_widget.dart';

class EvolutionSection extends StatelessWidget {
  final PokemonDetails pokemon;

  const EvolutionSection({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final evolutionChain = pokemon.evolutionChain;

    if (evolutionChain == null) {
      return const SizedBox.shrink();
    }

    final hasEvolutions = evolutionChain.species.length > 1;

    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section header
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: EvolutionConstants.cardPadding,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
            ),
            child: const Text(
              EvolutionConstants.sectionTitle,
              style: TextStyle(
                fontSize: AppConstants.fontSizeTitle,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppConstants.mediumPadding),

          // Content: evolution chain or no evolution message
          if (hasEvolutions)
            EvolutionChainWidget(
              chain: evolutionChain,
              currentPokemonId: pokemon.id,
            )
          else
            Center(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Text(
                  EvolutionConstants.noEvolutionMessage,
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeRegular,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
