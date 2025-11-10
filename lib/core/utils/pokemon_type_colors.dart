import 'package:flutter/material.dart';
import '../../features/pokemon/domain/entities/pokemon_types.dart';
import '../constants/ui_constants.dart';

class PokemonTypeColors {
  static const Map<PokemonTypes, Color> _typeColorMap = {
    PokemonTypes.fire: Colors.deepOrange,
    PokemonTypes.water: Colors.blue,
    PokemonTypes.grass: Colors.green,
    PokemonTypes.electric: Colors.amber,
    PokemonTypes.psychic: Colors.pink,
    PokemonTypes.ice: Colors.lightBlue,
    PokemonTypes.dragon: Color(0xFF1A237E),
    PokemonTypes.dark: Colors.black87,
    PokemonTypes.fairy: Colors.pinkAccent,
    PokemonTypes.normal: Colors.grey,
    PokemonTypes.fighting: Colors.red,
    PokemonTypes.flying: Colors.indigo,
    PokemonTypes.poison: Colors.purple,
    PokemonTypes.ground: Colors.brown,
    PokemonTypes.rock: Color(0xFF616161),
    PokemonTypes.bug: Colors.lightGreen,
    PokemonTypes.ghost: Colors.deepPurple,
    PokemonTypes.steel: Colors.blueGrey,
    PokemonTypes.monster: Colors.deepPurple,
    PokemonTypes.unknown: Colors.grey,
  };

  static Color getColorForType(PokemonTypes type) {
    return _typeColorMap[type] ?? Colors.grey;
  }

  static Color getBackgroundColorForType(PokemonTypes type, {double opacity = PokemonCardConstants.defaultGradientOpacity}) {
    return getColorForType(type).withValues(alpha: opacity);
  }
}
