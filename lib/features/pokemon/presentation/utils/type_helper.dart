import 'package:flutter/material.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/entities/pokemon_details.dart';
import '../../domain/entities/pokemon_types.dart';
import 'type_colors.dart';

/// Centralized helper for Pokemon type-related operations
class TypeHelper {
  TypeHelper._();

  /// Gets the primary type color from a Pokemon entity
  static Color getPrimaryTypeColor(Pokemon pokemon) {
    final primaryType = pokemon.types.isNotEmpty
        ? pokemon.types.first
        : PokemonTypes.normal;
    return TypeColors.getColorForType(primaryType);
  }

  /// Gets the primary type color from a PokemonDetails entity
  static Color getPrimaryTypeColorFromDetails(PokemonDetails pokemonDetails) {
    final primaryType = pokemonDetails.types.isNotEmpty
        ? pokemonDetails.types.first.name
        : 'normal';
    return TypeColors.getColor(primaryType);
  }

  /// Gets the primary type name from a Pokemon entity
  static String getPrimaryTypeName(Pokemon pokemon) {
    return pokemon.types.isNotEmpty ? pokemon.types.first.name : 'normal';
  }

  /// Gets the primary type name from a PokemonDetails entity
  static String getPrimaryTypeNameFromDetails(PokemonDetails pokemonDetails) {
    return pokemonDetails.types.isNotEmpty
        ? pokemonDetails.types.first.name
        : 'normal';
  }

  /// Gets type color from a type name string
  static Color getPrimaryTypeColorFromName(String typeName) {
    return TypeColors.getColor(typeName);
  }

  /// Gets all type colors from a Pokemon entity
  static List<Color> getAllTypeColors(Pokemon pokemon) {
    return pokemon.types
        .map((type) => TypeColors.getColorForType(type))
        .toList();
  }

  /// Gets all type colors from a PokemonDetails entity
  static List<Color> getAllTypeColorsFromDetails(PokemonDetails pokemonDetails) {
    return pokemonDetails.types
        .map((type) => TypeColors.getColor(type.name))
        .toList();
  }
}
