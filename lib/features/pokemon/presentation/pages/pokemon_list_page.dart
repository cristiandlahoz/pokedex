import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/core/constants/ui_constants.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/value_objects/filter_criteria.dart';
import '../../domain/value_objects/sort_criteria.dart';
import '../../bloc/pokemon_bloc.dart';
import '../../bloc/pokemon_event.dart';
import '../../bloc/pokemon_state.dart';
import '../utils/pokemon_navigation.dart';
import '../utils/scroll_pagination_mixin.dart';
import '../widgets/list_card/pokemon_list_app_bar.dart';
import '../widgets/list_card/pokemon_list_content.dart';
import '../widgets/list_card/pokemon_list_states.dart';
import '../widgets/menus/pokemon_filter_menu.dart';
import '../widgets/menus/pokemon_sort_menu.dart';

class PokemonListPage extends StatefulWidget {
  const PokemonListPage({super.key});

  @override
  State<PokemonListPage> createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage>
    with ScrollPaginationMixin {
  late final PokemonBloc _pokemonBloc;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceSearch;

  @override
  void initState() {
    super.initState();
    _initializeDependencies();
    _loadInitialData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    disposeScrollPagination();
    _pokemonBloc.close();
    _debounceSearch?.cancel();
    super.dispose();
  }

  void _initializeDependencies() {
    _pokemonBloc = getIt<PokemonBloc>();
    initializeScrollPagination(
      threshold: PokemonListPageConstants.scrollThreshold,
    );
  }

  @override
  bool get canLoadMore {
    final currentState = _pokemonBloc.state;
    return currentState is! PokemonLoadingMore &&
        currentState is PokemonLoaded &&
        !currentState.hasReachedMax;
  }

  @override
  void onLoadMore() => _pokemonBloc.add(const LoadMorePokemon());

  void _loadInitialData() => _pokemonBloc.add(const LoadPokemonList());

  void _handleRefresh() =>
      _pokemonBloc.add(const LoadPokemonList(isRefresh: true));

  void _handleSearchChanged(String query) {
    _debounceSearch?.cancel();
    _debounceSearch = Timer(const Duration(milliseconds: 500), () {
      _pokemonBloc.add(SearchPokemonEvent(query));
    });
  }

  void _handlePokemonTap(Pokemon pokemon) =>
      PokemonNavigation.navigateToDetails(context: context, pokemon: pokemon);

  void _handleSortPressed() {
    final currentState = _pokemonBloc.state;
    final currentSort = currentState is PokemonLoaded
        ? currentState.sortCriteria
        : SortCriteria.defaultCriteria;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PokemonSortMenu(
        currentSort: currentSort,
        onApply: (sortCriteria) {
          Navigator.pop(context);
          _pokemonBloc.add(ApplySortEvent(sortCriteria));
        },
      ),
    );
  }

  void _handleFilterPressed() {
    final currentState = _pokemonBloc.state;
    final currentFilter = currentState is PokemonLoaded
        ? currentState.filterCriteria
        : FilterCriteria.empty;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PokemonFilterMenu(
        currentFilter: currentFilter,
        onApply: (filterCriteria) {
          Navigator.pop(context);
          _pokemonBloc.add(ApplyFilterEvent(filterCriteria));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(
    value: _pokemonBloc,
    child: BlocBuilder<PokemonBloc, PokemonState>(
      builder: (context, state) {
        final filterCount = state is PokemonLoaded
            ? state.filterCriteria.activeFilterCount
            : 0;

        return Scaffold(
          appBar: PokemonListAppBar(
            searchController: _searchController,
            onSearchChanged: _handleSearchChanged,
            onSortPressed: _handleSortPressed,
            onFilterPressed: _handleFilterPressed,
            filterCount: filterCount,
          ),
          body: _buildStateContent(state),
        );
      },
    ),
  );

  Widget _buildStateContent(PokemonState state) => switch (state) {
    PokemonInitial() => const SizedBox.shrink(),
    PokemonLoading() => const PokemonLoadingState(),
    PokemonError() => PokemonErrorState(
      failure: state.failure,
      onRetry: _handleRefresh,
    ),
    PokemonLoadMoreError() => _buildLoadedContentWithError(state),
    PokemonLoaded() => PokemonListContent(
      state: state,
      scrollController: scrollController,
      onRefresh: _handleRefresh,
      onPokemonTap: _handlePokemonTap,
    ),
  };

  Widget _buildLoadedContentWithError(PokemonLoadMoreError state) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load more: ${state.failure.message}'),
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

    return PokemonListContent(
      state: state,
      scrollController: scrollController,
      onRefresh: _handleRefresh,
      onPokemonTap: _handlePokemonTap,
    );
  }
}
