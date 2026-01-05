import 'package:flutter/material.dart';

import '../../../domain/entities/pokemon_variety.dart';
import '../../utils/navigation.dart';
import '../../utils/type_converter.dart';
import '../shared/pokemon_card_base.dart';

class VarietyCard extends StatelessWidget {
  final PokemonVariety variety;
  final bool isCurrentPokemon;

  const VarietyCard({
    super.key,
    required this.variety,
    this.isCurrentPokemon = false,
  });

  @override
  Widget build(BuildContext context) {
    return PokemonCardBase(
      imageUrl: variety.imageUrl,
      types: variety.types.toPokemonTypes(),
      name: variety.displayName,
      showBorder: isCurrentPokemon,
      onTap: () =>
          Navigation.navigateToVariety(context: context, variety: variety),
    );
  }
}
