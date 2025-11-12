import 'package:flutter/material.dart';
import '../../domain/entities/pokemon.dart';
import '../pages/pokemon_details_page.dart';

class PokemonNavigation {
  static void navigateToDetails({
    required BuildContext context,
    required Pokemon pokemon,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PokemonDetailsPage(pokemon: pokemon),
      ),
    );
  }
}
