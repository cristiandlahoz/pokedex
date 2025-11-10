import 'package:flutter/material.dart';

class PokemonTypeColors {
  static const Map<String, Color> typeColors = {
    'fire': Color(0xFFFF6B3D),
    'water': Color(0xFF4D90D5),
    'grass': Color(0xFF5FBD58),
    'electric': Color(0xFFFFC631),
    'psychic': Color(0xFFFF6891),
    'ice': Color(0xFF7FCCEC),
    'dragon': Color(0xFF0A6DC4),
    'dark': Color(0xFF5A5465),
    'fairy': Color(0xFFEF90E6),
    'normal': Color(0xFFA0A2A0),
    'fighting': Color(0xFFD3425F),
    'flying': Color(0xFF89AAE3),
    'poison': Color(0xFFB563CE),
    'ground': Color(0xFFD97845),
    'rock': Color(0xFFC5B78C),
    'bug': Color(0xFF92BC2C),
    'ghost': Color(0xFF5F6DBC),
    'steel': Color(0xFF5695A3),
  };

  static Color getColor(String type) {
    return typeColors[type.toLowerCase()] ?? Colors.grey;
  }
}
