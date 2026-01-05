import 'package:flutter/material.dart';

import '../../../domain/entities/pokemon_variety.dart';
import '../../constants/evolution.dart';
import 'variety_card.dart';

class VarietiesListWidget extends StatelessWidget {
  final List<PokemonVariety> varieties;
  final int currentPokemonId;

  const VarietiesListWidget({
    super.key,
    required this.varieties,
    required this.currentPokemonId,
  });

  @override
  Widget build(BuildContext context) {
    if (varieties.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: EvolutionConstants.varietiesListHeight,
      child: Center(
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: varieties.length,
          separatorBuilder: (context, index) => const SizedBox(width: 12.0),
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          itemBuilder: (context, index) {
            return VarietyCard(
              variety: varieties[index],
              isCurrentPokemon: varieties[index].id == currentPokemonId,
            );
          },
        ),
      ),
    );
  }
}
