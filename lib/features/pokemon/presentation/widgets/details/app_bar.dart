import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app.dart';
import '../../../bloc/details_bloc.dart';
import '../../../bloc/details_event.dart';
import '../../../bloc/details_state.dart';
import '../../../domain/entities/pokemon_details.dart';
import '../favorite_toggle_button.dart';
import 'game_version_selector.dart';

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
        background: _buildBackground(context),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        BlocBuilder<DetailsBloc, DetailsState>(
          builder: (context, state) {
            final isShiny = state is DetailsSuccess ? state.isShiny : false;
            return IconButton(
              icon: Icon(
                isShiny ? Icons.auto_awesome : Icons.auto_awesome_outlined,
                color: Colors.white,
              ),
              tooltip: isShiny ? 'Show Normal' : 'Show Shiny',
              onPressed: () {
                context.read<DetailsBloc>().add(const DetailsShinyToggled());
              },
            );
          },
        ),
        FavoriteToggleButton(pokemon: pokemon, color: Colors.white),
      ],
    );
  }

  Widget _buildBackground(BuildContext context) {
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
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Flexible(
              child: _buildPokemonImage(context),
            ),
            const SizedBox(height: 8),
            const GameVersionSelector(),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildPokemonImage(BuildContext context) {
    return BlocBuilder<DetailsBloc, DetailsState>(
      builder: (context, state) {
        final isShiny = state is DetailsSuccess ? state.isShiny : false;
        final imageUrl = isShiny 
            ? (pokemon.shinyImageUrl ?? pokemon.imageUrl)
            : pokemon.imageUrl;

        return Center(
          child: Hero(
            tag: 'pokemon_${pokemon.id}',
            transitionOnUserGestures: true,
            child: CachedNetworkImage(
              imageUrl: imageUrl ?? '',
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
      },
    );
  }
}
