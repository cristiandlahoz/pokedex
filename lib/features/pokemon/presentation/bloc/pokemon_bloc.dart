import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_pokemon_list.dart';
import '../../domain/usecases/search_pokemon.dart';
import 'pokemon_event.dart';
import 'pokemon_state.dart';

@injectable
class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  final GetPokemonList getPokemonList;
  final SearchPokemon searchPokemon;

  PokemonBloc({
    required this.getPokemonList,
    required this.searchPokemon,
  }) : super(const PokemonInitial()) {
    on<LoadPokemonList>(_onLoadPokemonList);
    on<LoadMorePokemon>(_onLoadMorePokemon);
    on<SearchPokemonEvent>(_onSearchPokemon);
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
    );

    result.fold(
      (failure) => emit(PokemonError(failure.message)),
      (pokemons) {
        if (pokemons.isEmpty) {
          emit(const PokemonLoaded(
            pokemons: [],
            hasReachedMax: true,
            currentPage: 0,
          ));
        } else {
          emit(PokemonLoaded(
            pokemons: pokemons,
            hasReachedMax: pokemons.length < event.limit,
            currentPage: event.page,
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
    ));

    final nextPage = currentState.currentPage + 1;
    final result = await getPokemonList(
      page: nextPage,
      limit: 20,
    );

    result.fold(
      (failure) => emit(PokemonLoadMoreError(
        pokemons: currentState.pokemons,
        currentPage: currentState.currentPage,
        errorMessage: failure.message,
      )),
      (newPokemons) {
        if (newPokemons.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          emit(PokemonLoaded(
            pokemons: [...currentState.pokemons, ...newPokemons],
            hasReachedMax: newPokemons.length < 20,
            currentPage: nextPage,
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
      (failure) => emit(PokemonError(failure.message)),
      (pokemons) {
        emit(PokemonLoaded(
          pokemons: pokemons,
          hasReachedMax: true,
          currentPage: 0,
        ));
      },
    );
  }
}
