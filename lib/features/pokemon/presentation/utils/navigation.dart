import 'package:flutter/material.dart';

import '../../domain/entities/pokemon.dart';
import '../../domain/entities/pokemon_variety.dart';
import '../pages/details_page.dart';
import 'type_converter.dart';

class Navigation {
  Navigation._();

  static void navigateToDetails({
    required BuildContext context,
    required Pokemon pokemon,
    bool useFadeTransition = false,
  }) {
    final route = useFadeTransition
        ? _buildFadeRoute(pokemon)
        : MaterialPageRoute(
            builder: (context) => PokemonDetailsPage(pokemon: pokemon),
          );

    Navigator.of(context).push(route);
  }

  static void navigateToVariety({
    required BuildContext context,
    required PokemonVariety variety,
  }) {
    final pokemon = Pokemon(
      id: variety.id,
      name: variety.name,
      types: variety.types.toPokemonTypes(),
      imageUrl: variety.imageUrl,
    );

    Navigator.of(context).push(_buildFadeRoute(pokemon));
  }

  static PageRouteBuilder<dynamic> _buildFadeRoute(Pokemon pokemon) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          PokemonDetailsPage(pokemon: pokemon),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}
