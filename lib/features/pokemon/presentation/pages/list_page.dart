import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/pokemon.dart';
import '../constants/list.dart';
import '../../domain/value_objects/filters.dart';
import '../../domain/value_objects/sorting.dart';
import '../../bloc/list_bloc.dart';
import '../../bloc/list_event.dart';
import '../../bloc/list_state.dart';
import '../utils/navigation.dart';
import '../utils/scroll_pagination_mixin.dart';
import '../widgets/list/app_bar.dart';
import '../widgets/list/content.dart';
import '../widgets/list/states.dart' as list_states;
import '../widgets/menus/filter_menu.dart';
import '../widgets/menus/sort_menu.dart';

class PokemonListPage extends StatefulWidget {
  const PokemonListPage({super.key});

  @override
  State<PokemonListPage> createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage>
    with ScrollPaginationMixin {
  late final ListBloc _pokemonBloc;
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
    _pokemonBloc = getIt<ListBloc>();
    initializeScrollPagination(threshold: ListConstants.scrollThreshold);
  }

  @override
  bool get canLoadMore {
    final currentState = _pokemonBloc.state;
    return currentState is! ListLoadingMore &&
        currentState is ListSuccess &&
        !currentState.hasReachedMax;
  }

  @override
  void onLoadMore() => _pokemonBloc.add(const ListLoadMoreRequested());

  void _loadInitialData() => _pokemonBloc.add(const ListLoadRequested());

  void _handleRefresh() =>
      _pokemonBloc.add(const ListLoadRequested(isRefresh: true));

  void _handleSearchChanged(String query) {
    _debounceSearch?.cancel();
    _debounceSearch = Timer(const Duration(milliseconds: 500), () {
      _pokemonBloc.add(ListSearchSubmitted(query));
    });
  }

  void _handlePokemonTap(Pokemon pokemon) =>
      Navigation.navigateToDetails(context: context, pokemon: pokemon);

  void _handleSortPressed() {
    final currentState = _pokemonBloc.state;
    final currentSort = currentState is ListSuccess
        ? currentState.sort
        : Sorting.defaultCriteria;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SortMenu(
        currentSort: currentSort,
        onApply: (sort) {
          Navigator.pop(context);
          _pokemonBloc.add(ListSortApplied(sort));
        },
      ),
    );
  }

  void _handleFilterPressed() {
    final currentState = _pokemonBloc.state;
    final currentFilter = currentState is ListSuccess
        ? currentState.filter
        : Filters.empty;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterMenu(
        currentFilter: currentFilter,
        onApply: (filter) {
          Navigator.pop(context);
          _pokemonBloc.add(ListFilterApplied(filter));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => BlocProvider.value(
    value: _pokemonBloc,
    child: BlocBuilder<ListBloc, ListState>(
      builder: (context, state) {
        final filterCount = state is ListSuccess
            ? state.filter.activeFilterCount
            : 0;

        return Scaffold(
          appBar: ListAppBar(
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

  Widget _buildStateContent(ListState state) => switch (state) {
    ListInitial() => const SizedBox.shrink(),
    ListLoading() => const list_states.LoadingState(),
    ListFailure() => list_states.ErrorState(
      failure: state.failure,
      onRetry: _handleRefresh,
    ),
    ListLoadMoreFailure() => _buildLoadedContentWithError(state),
    ListSuccess() => ListContent(
      state: state,
      scrollController: scrollController,
      onRefresh: _handleRefresh,
      onPokemonTap: _handlePokemonTap,
    ),
  };

  Widget _buildLoadedContentWithError(ListLoadMoreFailure state) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load more: ${state.failure.message}'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: () => _pokemonBloc.add(const ListLoadMoreRequested()),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    });

    return ListContent(
      state: state,
      scrollController: scrollController,
      onRefresh: _handleRefresh,
      onPokemonTap: _handlePokemonTap,
    );
  }
}
