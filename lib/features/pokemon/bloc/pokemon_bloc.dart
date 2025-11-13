import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_pokemon_list.dart';
import '../../domain/usecases/search_pokemon.dart';
import '../../domain/value_objects/filter_criteria.dart';
import '../../domain/value_objects/sort_criteria.dart';
import 'pokemon_event.dart';
import 'pokemon_state.dart';

@injectable
class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final GetPokemonList getPokemonList;
  final SearchPokemon searchPokemon;

  SortCriteria _currentSort = SortCriteria.defaultCriteria;
  FilterCriteria _currentFilter = FilterCriteria.empty;

  PokemonBloc({
    required this.getPokemonList,
    required this.searchPokemon,
  }) : super(const PokemonInitial()) {
    on<LoadPokemonList>(_onLoadPokemonList);
    on<LoadMorePokemon>(_onLoadMorePokemon);
    on<SearchPokemonEvent>(_onSearchPokemon);
    on<ApplySortEvent>(_onApplySort);
    on<ApplyFilterEvent>(_onApplyFilter);
    on<ClearFiltersEvent>(_onClearFilters);
  }

  Future<void> _onLoadPokemonList(
    LoadPokemonList event,
    Emitter<PokemonState> emit,
  ) async {
    if (event.isRefresh || state is! PokemonLoaded) {
      emit(const PokemonLoading());
    }

    final result = await getPokemonList(
      page: event.page,
      limit: event.limit,
      sortCriteria: _currentSort,
      filterCriteria: _currentFilter,
    );

    result.fold(
      (failure) => emit(PokemonError(failure)),
      (pokemons) {
        if (pokemons.isEmpty) {
          emit(PokemonLoaded(
            pokemons: const [],
            hasReachedMax: true,
            currentPage: 0,
            sortCriteria: _currentSort,
            filterCriteria: _currentFilter,
          ));
        } else {
          emit(PokemonLoaded(
            pokemons: pokemons,
            hasReachedMax: pokemons.length < event.limit,
            currentPage: event.page,
            sortCriteria: _currentSort,
            filterCriteria: _currentFilter,
          ));
        }
      },
    );
  }

  Future<void> _onLoadMorePokemon(
    LoadMorePokemon event,
    Emitter<PokemonState> emit,
  ) async {
    final currentState = state;
    if (currentState is! PokemonLoaded || 
        currentState.hasReachedMax ||
        currentState is PokemonLoadingMore) {
      return;
    }

    emit(PokemonLoadingMore(
      pokemons: currentState.pokemons,
      currentPage: currentState.currentPage,
      sortCriteria: currentState.sortCriteria,
      filterCriteria: currentState.filterCriteria,
    ));

    final nextPage = currentState.currentPage + 1;
    final result = await getPokemonList(
      page: nextPage,
      limit: AppDesignTokens.defaultPageSize,
      sortCriteria: _currentSort,
      filterCriteria: _currentFilter,
    );

    result.fold(
      (failure) => emit(PokemonLoadMoreError(
        pokemons: currentState.pokemons,
        currentPage: currentState.currentPage,
        sortCriteria: currentState.sortCriteria,
        filterCriteria: currentState.filterCriteria,
        failure: failure,
      )),
      (newPokemons) {
        if (newPokemons.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          emit(PokemonLoaded(
            pokemons: [...currentState.pokemons, ...newPokemons],
            hasReachedMax: newPokemons.length < 20,
            currentPage: nextPage,
            sortCriteria: currentState.sortCriteria,
            filterCriteria: currentState.filterCriteria,
          ));
        }
      },
    );
  }

  Future<void> _onSearchPokemon(
    SearchPokemonEvent event,
    Emitter<PokemonState> emit,
  ) async {
    if (event.query.isEmpty) {
      add(const LoadPokemonList(isRefresh: true));
      return;
    }

    emit(const PokemonLoading());

    final result = await searchPokemon(event.query);

    result.fold(
      (failure) => emit(PokemonError(failure)),
      (pokemons) {
        emit(PokemonLoaded(
          pokemons: pokemons,
          hasReachedMax: true,
          currentPage: 0,
          sortCriteria: _currentSort,
          filterCriteria: _currentFilter,
        ));
      },
    );
  }

  Future<void> _onApplySort(
    ApplySortEvent event,
    Emitter<PokemonState> emit,
  ) async {
    _currentSort = event.sortCriteria;
    add(const LoadPokemonList(isRefresh: true));
  }

  Future<void> _onApplyFilter(
    ApplyFilterEvent event,
    Emitter<PokemonState> emit,
  ) async {
    _currentFilter = event.filterCriteria;
    add(const LoadPokemonList(isRefresh: true));
  }

  Future<void> _onClearFilters(
    ClearFiltersEvent event,
    Emitter<PokemonState> emit,
  ) async {
    _currentFilter = FilterCriteria.empty;
    add(const LoadPokemonList(isRefresh: true));
  }
}
