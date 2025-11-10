import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/pokemon.dart';

class PokemonDetailAppBar extends StatelessWidget {
  final Pokemon pokemon;
  final Color backgroundColor;

  const PokemonDetailAppBar({
    super.key,
    required this.pokemon,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: AppConstants.appBarExpandedHeight,
      pinned: true,
      backgroundColor: backgroundColor,
      flexibleSpace: FlexibleSpaceBar(
        background: _buildBackground(),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.favorite_border, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            backgroundColor,
            backgroundColor.withValues(alpha: AppConstants.opacityMedium),
          ],
        ),
      ),
      child: Stack(
        children: [
          _buildPokeballWatermark(),
          _buildPokemonImage(),
        ],
      ),
    );
  }

  Widget _buildPokeballWatermark() {
    return const Positioned(
      right: -30,
      top: -30,
      child: Opacity(
        opacity: AppConstants.opacityLight,
        child: Icon(
          Icons.catching_pokemon,
          size: AppConstants.iconSizeExtraLarge,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildPokemonImage() {
    return Center(
      child: Hero(
        tag: 'pokemon_${pokemon.id}',
        child: Image.network(
          pokemon.imageUrl,
          height: AppConstants.pokemonImageHeight,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.error_outline,
              size: AppConstants.iconSizeLarge,
              color: Colors.white70,
            );
          },
        ),
      ),
    );
  }
}
