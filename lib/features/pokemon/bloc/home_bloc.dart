import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../core/theme/tokens.dart';
import '../../../core/utils/result.dart';
import '../domain/repositories/pokemon_repository.dart';
import '../domain/value_objects/filters.dart';
import '../domain/value_objects/sorting.dart';
import 'list_event.dart';
import 'list_state.dart';

@injectable
class ListBloc extends Bloc<ListEvent, ListState> {
  final PokemonRepository repository;

  Sorting _currentSort = Sorting.defaultCriteria;
  Filters _currentFilter = Filters.empty;

  ListBloc({required this.repository})
    : super(const ListInitial()) {
    on<ListLoadRequested>(_onListLoadRequested);
    on<ListLoadMoreRequested>(_onListLoadMoreRequested);
    on<ListSearchSubmitted>(_onListSearchSubmitted);
    on<ListSortApplied>(_onListSortApplied);
    on<ListFilterApplied>(_onListFilterApplied);
    on<ListFiltersCleared>(_onListFiltersCleared);
  }

  Future<void> _onListLoadRequested(
    ListLoadRequested event,
    Emitter<ListState> emit,
  ) async {
    if (event.isRefresh || state is! ListSuccess) {
      emit(const ListLoading());
    }

    final result = await repository.getPokemonList(
      page: event.page,
      limit: event.limit,
      sort: _currentSort,
      filter: _currentFilter,
    );

    switch (result) {
      case Success(:final data):
        if (data.isEmpty) {
          emit(
            ListSuccess(
              pokemons: const [],
              hasReachedMax: true,
              currentPage: 0,
              sort: _currentSort,
              filter: _currentFilter,
            ),
          );
        } else {
          emit(
            ListSuccess(
              pokemons: data,
              hasReachedMax: data.length < event.limit,
              currentPage: event.page,
              sort: _currentSort,
              filter: _currentFilter,
            ),
          );
        }
      case Failure(:final failure):
        emit(ListFailure(failure));
    }
  }

  Future<void> _onListLoadMoreRequested(
    ListLoadMoreRequested event,
    Emitter<ListState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ListSuccess ||
        currentState.hasReachedMax ||
        currentState is ListLoadingMore) {
      return;
    }

    emit(
      ListLoadingMore(
        pokemons: currentState.pokemons,
        currentPage: currentState.currentPage,
        sort: currentState.sort,
        filter: currentState.filter,
      ),
    );

    final nextPage = currentState.currentPage + 1;
    final result = await repository.getPokemonList(
      page: nextPage,
      limit: DesignTokens.defaultPageSize,
      sort: _currentSort,
      filter: _currentFilter,
    );

    switch (result) {
      case Success(:final data):
        if (data.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          emit(
            ListSuccess(
              pokemons: [...currentState.pokemons, ...data],
              hasReachedMax: data.length < DesignTokens.defaultPageSize,
              currentPage: nextPage,
              sort: currentState.sort,
              filter: currentState.filter,
            ),
          );
        }
      case Failure(:final failure):
        emit(
          ListLoadMoreFailure(
            pokemons: currentState.pokemons,
            currentPage: currentState.currentPage,
            sort: currentState.sort,
            filter: currentState.filter,
            failure: failure,
          ),
        );
    }
  }

  Future<void> _onListSearchSubmitted(
    ListSearchSubmitted event,
    Emitter<ListState> emit,
  ) async {
    if (event.query.isEmpty) {
      add(const ListLoadRequested(isRefresh: true));
      return;
    }

    emit(const ListLoading());

    final result = await repository.searchPokemon(event.query);

    switch (result) {
      case Success(:final data):
        emit(
          ListSuccess(
            pokemons: data,
            hasReachedMax: true,
            currentPage: 0,
            sort: _currentSort,
            filter: _currentFilter,
          ),
        );
      case Failure(:final failure):
        emit(ListFailure(failure));
    }
  }

  Future<void> _onListSortApplied(
    ListSortApplied event,
    Emitter<ListState> emit,
  ) async {
    _currentSort = event.sort;
    add(const ListLoadRequested(isRefresh: true));
  }

  Future<void> _onListFilterApplied(
    ListFilterApplied event,
    Emitter<ListState> emit,
  ) async {
    _currentFilter = event.filter;
    add(const ListLoadRequested(isRefresh: true));
  }

  Future<void> _onListFiltersCleared(
    ListFiltersCleared event,
    Emitter<ListState> emit,
  ) async {
    _currentFilter = Filters.empty;
    add(const ListLoadRequested(isRefresh: true));
  }
}
