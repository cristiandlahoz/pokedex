import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../core/constants/app.dart';
import '../../../domain/entities/pokemon_details.dart';

class DetailsAppBar extends StatelessWidget {
  final PokemonDetails pokemon;
  final Color backgroundColor;

  const DetailsAppBar({
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
      child: _buildPokemonImage(),
    );
  }

  Widget _buildPokemonImage() {
    return Center(
      child: Hero(
        tag: 'pokemon_${pokemon.id}',
        transitionOnUserGestures: true,
        child: CachedNetworkImage(
          imageUrl: pokemon.imageUrl ?? '',
          width: AppConstants.pokemonImageHeight,
          height: AppConstants.pokemonImageHeight,
          fit: BoxFit.contain,
          placeholder: (context, url) => SizedBox(
            width: AppConstants.pokemonImageHeight,
            height: AppConstants.pokemonImageHeight,
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          ),
          errorWidget: (context, url, error) => const Center(
            child: Icon(
              Icons.error_outline,
              size: AppConstants.iconSizeLarge,
              color: Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}
