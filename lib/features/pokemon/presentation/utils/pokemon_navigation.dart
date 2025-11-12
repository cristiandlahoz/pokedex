import 'package:flutter/material.dart';
import '../../domain/entities/pokemon.dart';
import '../pages/pokemon_details_page.dart';

class PokemonNavigation {
  static void navigateToDetails({
    required BuildContext context,
    required Pokemon pokemon,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            PokemonDetailsPage(pokemon: pokemon),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeOutCubic;
          final tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }
}
