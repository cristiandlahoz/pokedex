import 'package:flutter/material.dart';
import '../../domain/entities/pokemon_types.dart';
import '../../domain/entities/pokemon_generation.dart';
import '../utils/pokemon_type_colors.dart';

class TypeFilterItem {
  final PokemonTypes type;
  final String label;
  final Color color;

  const TypeFilterItem({
    required this.type,
    required this.label,
    required this.color,
  });

  static List<TypeFilterItem> get allTypes {
    return [
      PokemonTypes.normal,
      PokemonTypes.fire,
      PokemonTypes.water,
      PokemonTypes.electric,
      PokemonTypes.grass,
      PokemonTypes.ice,
      PokemonTypes.fighting,
      PokemonTypes.poison,
      PokemonTypes.ground,
      PokemonTypes.flying,
      PokemonTypes.psychic,
      PokemonTypes.bug,
      PokemonTypes.rock,
      PokemonTypes.ghost,
      PokemonTypes.dragon,
      PokemonTypes.dark,
      PokemonTypes.steel,
      PokemonTypes.fairy,
    ].map((type) {
      return TypeFilterItem(
        type: type,
        label: type.displayName,
        color: PokemonTypeColors.getTypeColor(type),
      );
    }).toList();
  }
}

class GenerationFilterItem {
  final PokemonGeneration generation;
  final String label;
  final String region;
  final String range;

  const GenerationFilterItem({
    required this.generation,
    required this.label,
    required this.region,
    required this.range,
  });

  static List<GenerationFilterItem> get allGenerations {
    return PokemonGeneration.values.map((gen) {
      return GenerationFilterItem(
        generation: gen,
        label: gen.shortName,
        region: gen.region,
        range: gen.range,
      );
    }).toList();
  }
}
