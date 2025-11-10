import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/core/constants/ui_constants.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/pokemon.dart';
import '../bloc/pokemon_bloc.dart';
import '../bloc/pokemon_event.dart';
import '../bloc/pokemon_state.dart';
import '../widgets/pokemon_card.dart';
import 'pokemon_details_page.dart';

class PokemonListPage extends StatefulWidget {
  const PokemonListPage({super.key});

  @override
  State<PokemonListPage> createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isNearScrollThreshold) {
      context.read<PokemonBloc>().add(const LoadMorePokemon());
    }
  }

  bool get _isNearScrollThreshold {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * PokemonListPageConstants.scrollThreshold);
  }

  void _handleRefresh() {
    context.read<PokemonBloc>().add(const LoadPokemonList(isRefresh: true));
  }

  void _handlePokemonTap(Pokemon pokemon) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            PokemonDetailsPage(pokemon: pokemon),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          final tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PokemonBloc>()..add(const LoadPokemonList()),
      child: Scaffold(
        appBar: _PokemonListAppBar(),
        body: BlocBuilder<PokemonBloc, PokemonState>(
          builder: (context, state) => _buildStateContent(state),
        ),
      ),
    );
  }

  Widget _buildStateContent(PokemonState state) {
    return switch (state) {
      PokemonLoading() => const _LoadingStateWidget(),
      PokemonError() => _ErrorStateWidget(
          message: state.message,
          onRetry: _handleRefresh,
        ),
      PokemonLoaded() => _buildLoadedContent(state),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildLoadedContent(PokemonLoaded state) {
    if (state.pokemons.isEmpty) {
      return const _EmptyStateWidget();
    }

    return _PokemonListView(
      state: state,
      scrollController: _scrollController,
      onRefresh: _handleRefresh,
      onPokemonTap: _handlePokemonTap,
    );
  }
}

class _PokemonListAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Pokédex',
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      backgroundColor: Colors.deepOrange,
      foregroundColor: Colors.white,
      elevation: App.appBarElevation,
    );
  }
}

class _LoadingStateWidget extends StatelessWidget {
  const _LoadingStateWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _ErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorStateWidget({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: PokemonListPageConstants.errorIconSize,
            color: Colors.red,
          ),
          const SizedBox(height: PokemonListPageConstants.errorSpacing),
          Text(
            'Error: $message',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: PokemonListPageConstants.errorTextSize,
            ),
          ),
          const SizedBox(height: PokemonListPageConstants.errorSpacing),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyStateWidget extends StatelessWidget {
  const _EmptyStateWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No Pokémon found',
        style: TextStyle(
          fontSize: PokemonListPageConstants.emptyStateTextSize,
        ),
      ),
    );
  }
}

class _PokemonListView extends StatelessWidget {
  final PokemonLoaded state;
  final ScrollController scrollController;
  final VoidCallback onRefresh;
  final void Function(Pokemon) onPokemonTap;

  const _PokemonListView({
    required this.state,
    required this.scrollController,
    required this.onRefresh,
    required this.onPokemonTap,
  });

  @override
  Widget build(BuildContext context) {
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

  int _calculateItemCount() {
    return state.hasReachedMax
        ? state.pokemons.length
        : state.pokemons.length + 1;
  }

  Widget _buildListItem(int index) {
    if (index >= state.pokemons.length) {
      return const _LoadingMoreIndicator();
    }

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

class _LoadingMoreIndicator extends StatelessWidget {
  const _LoadingMoreIndicator();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(PokemonListPageConstants.loadingIndicatorPadding),
        child: CircularProgressIndicator(),
      ),
    );
  }
}
