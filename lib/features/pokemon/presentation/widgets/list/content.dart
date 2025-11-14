import 'package:flutter/material.dart' hide Card;
import '../../constants/list.dart';
import '../../../domain/entities/pokemon.dart';
import '../../../bloc/list_state.dart';
import 'card.dart';
import 'states.dart';

class ListContent extends StatelessWidget {
  final ListSuccess state;
  final ScrollController scrollController;
  final VoidCallback onRefresh;
  final void Function(Pokemon) onPokemonTap;

  const ListContent({
    super.key,
    required this.state,
    required this.scrollController,
    required this.onRefresh,
    required this.onPokemonTap,
  });

  @override
  Widget build(BuildContext context) {
    if (state.pokemons.isEmpty) return const EmptyState();

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(
          horizontal: ListConstants.listHorizontalPadding,
          vertical: ListConstants.listVerticalPadding,
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
    if (index >= state.pokemons.length) return const LoadingState();

    final pokemon = state.pokemons[index];
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: ListConstants.listItemVerticalPadding,
      ),
      child: Card(
        pokemon: pokemon,
        onTap: () => onPokemonTap(pokemon),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    onRefresh();
    await Future.delayed(
      const Duration(
        milliseconds: ListConstants.refreshDelayDuration,
      ),
    );
  }
}
