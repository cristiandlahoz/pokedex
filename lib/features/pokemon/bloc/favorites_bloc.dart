import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/utils/result.dart';
import '../domain/repositories/favorites_repository.dart';
import '../domain/repositories/pokemon_repository.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

@injectable
class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoritesRepository favoritesRepository;
  final PokemonRepository pokemonRepository;

  FavoritesBloc({
    required this.favoritesRepository,
    required this.pokemonRepository,
  }) : super(const FavoritesInitial()) {
    on<FavoritesLoadRequested>(_onFavoritesLoadRequested);
    on<FavoriteToggled>(_onFavoriteToggled);
  }

  Future<void> _onFavoritesLoadRequested(
    FavoritesLoadRequested event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await favoritesRepository.getFavoriteIds();

    switch (result) {
      case Success(:final data):
        emit(FavoritesLoaded(data));
      case ResultFailure():
        emit(const FavoritesLoaded({}));
    }
  }

  Future<void> _onFavoriteToggled(
    FavoriteToggled event,
    Emitter<FavoritesState> emit,
  ) async {
    final currentState = state;
    if (currentState is! FavoritesLoaded && currentState is! FavoritesError) {
      return;
    }

    final currentFavoriteIds = switch (currentState) {
      FavoritesLoaded(:final favoriteIds) => favoriteIds,
      FavoritesError(:final favoriteIds) => favoriteIds,
      _ => <int>{},
    };

    final isFavorited = currentFavoriteIds.contains(event.pokemon.id);

    if (isFavorited) {
      await favoritesRepository.removeFavorite(event.pokemon.id);
      add(const FavoritesLoadRequested());
    } else {
      final detailsResult = await pokemonRepository.getPokemonDetails(
        event.pokemon.id,
      );

      switch (detailsResult) {
        case Success(:final data):
          await favoritesRepository.addFavoriteDetails(data);
          add(const FavoritesLoadRequested());

        case ResultFailure(:final failure):
          emit(
            FavoritesError(
              message: failure.message,
              favoriteIds: currentFavoriteIds,
            ),
          );
      }
    }
  }
}
