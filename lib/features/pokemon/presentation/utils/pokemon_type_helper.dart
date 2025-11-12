import 'package:flutter/material.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/entities/pokemon_types.dart';
import 'pokemon_type_colors.dart';

class PokemonTypeHelper {
  static Color getPrimaryTypeColor(Pokemon pokemon) {
    final primaryType = pokemon.types.isNotEmpty
        ? pokemon.types.first
        : PokemonTypes.normal;
    return PokemonTypeColors.getColorForType(primaryType);
  }

  static String getPrimaryTypeName(Pokemon pokemon) {
    return pokemon.types.isNotEmpty 
        ? pokemon.types.first.name 
        : 'normal';
  }

  static Color getPrimaryTypeColorFromName(String typeName) {
    return PokemonTypeColors.getColor(typeName);
  }
}
