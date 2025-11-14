import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../domain/entities/pokemon_types.dart';

class TypeIcons {
  static String getIconPath(PokemonTypes type) {
    return 'assets/icons/types/${type.name.toLowerCase()}.svg';
  }

  static Widget getTypeIcon(
    PokemonTypes type, {
    double? size,
    Color? color,
  }) {
    return SvgPicture.asset(
      getIconPath(type),
      width: size,
      height: size,
      colorFilter: color != null
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : null,
    );
  }
}
