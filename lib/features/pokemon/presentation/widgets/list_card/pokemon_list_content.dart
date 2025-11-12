import 'package:flutter/material.dart';
import '../../../../../core/constants/ui_constants.dart';
import '../../../domain/entities/pokemon.dart';
import '../../bloc/pokemon_state.dart';
import 'pokemon_card.dart';
import 'pokemon_list_states.dart';

class PokemonListContent extends StatelessWidget {
  final PokemonLoaded state;
  final ScrollController scrollController;
  final VoidCallback onRefresh;
  final void Function(Pokemon) onPokemonTap;

  const PokemonListContent({
    super.key,
    required this.state,
    required this.scrollController,
    required this.onRefresh,
    required this.onPokemonTap,
  });

  @override
  Widget build(BuildContext context) {
    if (state.pokemons.isEmpty) return const PokemonEmptyState();

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(
          horizontal: PokemonListPageConstants.listHorizontalPadding,
          vertical: PokemonListPageConstants.listVerticalPadding,
        ),
        itemCount: _calculateItemCount(),
        itemBuilder: (context, index) => _buildListItem(index),
      ),
    );
  }

  int _calculateItemCount() => state.hasReachedMax
      ? state.pokemons.length
      : state.pokemons.length + 1;

  Widget _buildListItem(int index) {
    if (index >= state.pokemons.length) return const PokemonLoadingState();

    final pokemon = state.pokemons[index];
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: PokemonListPageConstants.listItemVerticalPadding,
      ),
      child: PokemonCard(
        pokemon: pokemon,
        onTap: () => onPokemonTap(pokemon),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    onRefresh();
    await Future.delayed(
      const Duration(
        milliseconds: PokemonListPageConstants.refreshDelayDuration,
      ),
    );
  }
}
