import 'package:flutter/material.dart';
import '../../../../core/constants/ui_constants.dart';
import '../../domain/entities/pokemon_types.dart';

class PokemonTypeColors {
  static const Map<PokemonTypes, Color> _typeColorMap = {
    PokemonTypes.fire: Color(0xFFFF6B3D),
    PokemonTypes.water: Color(0xFF4D90D5),
    PokemonTypes.grass: Color(0xFF5FBD58),
    PokemonTypes.electric: Color(0xFFFFC631),
    PokemonTypes.psychic: Color(0xFFFF6891),
    PokemonTypes.ice: Color(0xFF7FCCEC),
    PokemonTypes.dragon: Color(0xFF0A6DC4),
    PokemonTypes.dark: Color(0xFF5A5465),
    PokemonTypes.fairy: Color(0xFFEF90E6),
    PokemonTypes.normal: Color(0xFFA0A2A0),
    PokemonTypes.fighting: Color(0xFFD3425F),
    PokemonTypes.flying: Color(0xFF89AAE3),
    PokemonTypes.poison: Color(0xFFB563CE),
    PokemonTypes.ground: Color(0xFFD97845),
    PokemonTypes.rock: Color(0xFFC5B78C),
    PokemonTypes.bug: Color(0xFF92BC2C),
    PokemonTypes.ghost: Color(0xFF5F6DBC),
    PokemonTypes.steel: Color(0xFF5695A3),
    PokemonTypes.monster: Colors.deepPurple,
    PokemonTypes.unknown: Colors.grey,
  };

  static Color getColorForType(PokemonTypes type) {
    return _typeColorMap[type] ?? Colors.grey;
  }

  static Color getTypeColor(PokemonTypes type) {
    return getColorForType(type);
  }

  static Color getColor(String typeName) {
    final type = PokemonTypeExtension.fromString(typeName);
    return getColorForType(type);
  }

  static Color getBackgroundColorForType(
    PokemonTypes type, {
    double opacity = PokemonCardConstants.defaultGradientOpacity,
  }) {
    return getColorForType(type).withValues(alpha: opacity);
  }
}
