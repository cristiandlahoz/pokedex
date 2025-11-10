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
  late final PokemonBloc _pokemonBloc;

  @override
  void initState() {
    super.initState();
    _pokemonBloc = getIt<PokemonBloc>()..add(const LoadPokemonList());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pokemonBloc.close();
    super.dispose();
  }

  void _onScroll() {
    final currentState = _pokemonBloc.state;

    if (currentState is PokemonLoadingMore) return;
    if (currentState is PokemonLoaded && currentState.hasReachedMax) return;

    if (_isNearScrollThreshold) {
      _pokemonBloc.add(const LoadMorePokemon());
    }
  }

  bool get _isNearScrollThreshold {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >=
        (maxScroll * PokemonListPageConstants.scrollThreshold);
  }

  void _handleRefresh() {
    _pokemonBloc.add(const LoadPokemonList(isRefresh: true));
  }

  void _handlePokemonTap(Pokemon pokemon) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            PokemonDetailsPage(pokemon: pokemon),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeOutCubic;
          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  final SearchController controller = SearchController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _pokemonBloc,
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
      PokemonLoadMoreError() => _buildLoadedContentWithError(state),
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

  Widget _buildLoadedContentWithError(PokemonLoadMoreError state) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load more: ${state.errorMessage}'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: () => _pokemonBloc.add(const LoadMorePokemon()),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    });

    return _buildLoadedContent(state);
  }
}

class _PokemonListAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(120);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: const SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Pokédex',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrange,
                ),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search Pokémon...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorStateWidget({required this.message, required this.onRetry});

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
        style: TextStyle(fontSize: PokemonListPageConstants.emptyStateTextSize),
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
      return const _LoadingStateWidget();
    }

    final pokemon = state.pokemons[index];
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: PokemonListPageConstants.listItemVerticalPadding,
      ),
      child: PokemonCard(pokemon: pokemon, onTap: () => onPokemonTap(pokemon)),
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

class _LoadingStateWidget extends StatelessWidget {
  const _LoadingStateWidget();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(
          PokemonListPageConstants.loadingIndicatorPadding,
        ),
        child: LinearProgressIndicator(color: Colors.deepOrange),
      ),
    );
  }
}
