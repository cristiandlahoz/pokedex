import 'package:flutter/material.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/entities/pokemon_details.dart';
import '../../domain/entities/pokemon_types.dart';
import 'pokemon_type_colors.dart';

/// Centralized helper for Pokemon type-related operations
/// Eliminates duplicate type color extraction across widgets
class PokemonTypeHelper {
  PokemonTypeHelper._();

  /// Gets the primary type color from a Pokemon entity
  static Color getPrimaryTypeColor(Pokemon pokemon) {
    final primaryType = pokemon.types.isNotEmpty
        ? pokemon.types.first
        : PokemonTypes.normal;
    return PokemonTypeColors.getColorForType(primaryType);
  }

  /// Gets the primary type color from a PokemonDetails entity
  static Color getPrimaryTypeColorFromDetails(PokemonDetails pokemonDetails) {
    final primaryType = pokemonDetails.types.isNotEmpty
        ? pokemonDetails.types.first.name
        : 'normal';
    return PokemonTypeColors.getColor(primaryType);
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
    return PokemonTypeColors.getColor(typeName);
  }

  /// Gets all type colors from a Pokemon entity
  static List<Color> getAllTypeColors(Pokemon pokemon) {
    return pokemon.types
        .map((type) => PokemonTypeColors.getColorForType(type))
        .toList();
  }

  /// Gets all type colors from a PokemonDetails entity
  static List<Color> getAllTypeColorsFromDetails(PokemonDetails pokemonDetails) {
    return pokemonDetails.types
        .map((type) => PokemonTypeColors.getColor(type.name))
        .toList();
  }
}
