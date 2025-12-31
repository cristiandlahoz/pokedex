import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../core/utils/result.dart';
import '../domain/entities/pokemon_details.dart';
import '../domain/repositories/pokemon_repository.dart';
import 'details_event.dart';
import 'details_state.dart';

@injectable
class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final PokemonRepository repository;

  DetailsBloc({required this.repository}) : super(const DetailsInitial()) {
    on<DetailsLoadRequested>(_onDetailsLoadRequested);
    on<DetailsLoadMoreMovesRequested>(_onDetailsLoadMoreMovesRequested);
  }

  Future<void> _onDetailsLoadRequested(
    DetailsLoadRequested event,
    Emitter<DetailsState> emit,
  ) async {
    emit(const DetailsLoading());

    final result = await repository.getPokemonDetails(
      event.pokemonId,
      movesPage: 0,
    );

    switch (result) {
      case Success(:final data):
        emit(DetailsSuccess(
          data,
          hasMoreMoves: data.moves.length >= repository.movesPageSize,
          currentMovesPage: 0,
        ));
      case ResultFailure(:final failure):
        emit(DetailsFailure(failure));
    }
  }

  Future<void> _onDetailsLoadMoreMovesRequested(
    DetailsLoadMoreMovesRequested event,
    Emitter<DetailsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! DetailsSuccess ||
        !currentState.hasMoreMoves ||
        currentState is DetailsLoadingMoreMoves) {
      return;
    }

    emit(DetailsLoadingMoreMoves(
      currentState.pokemon,
      hasMoreMoves: currentState.hasMoreMoves,
      currentMovesPage: currentState.currentMovesPage,
    ));

    final nextPage = currentState.currentMovesPage + 1;
    final result = await repository.getPokemonMovesPage(
      event.pokemonId,
      page: nextPage,
    );

    switch (result) {
      case Success(:final data):
        final updatedMoves = [...currentState.pokemon.moves, ...data];
        final updatedPokemon = PokemonDetails(
          id: currentState.pokemon.id,
          name: currentState.pokemon.name,
          types: currentState.pokemon.types,
          imageUrl: currentState.pokemon.imageUrl,
          height: currentState.pokemon.height,
          weight: currentState.pokemon.weight,
          genus: currentState.pokemon.genus,
          description: currentState.pokemon.description,
          abilities: currentState.pokemon.abilities,
          stats: currentState.pokemon.stats,
          moves: updatedMoves,
          baseExperience: currentState.pokemon.baseExperience,
          captureRate: currentState.pokemon.captureRate,
          baseHappiness: currentState.pokemon.baseHappiness,
          growthRate: currentState.pokemon.growthRate,
          eggGroup: currentState.pokemon.eggGroup,
          genderRatio: currentState.pokemon.genderRatio,
          eggGroups: currentState.pokemon.eggGroups,
          typeDefenses: currentState.pokemon.typeDefenses,
          typeOffenses: currentState.pokemon.typeOffenses,
        );

        emit(DetailsSuccess(
          updatedPokemon,
          hasMoreMoves: data.length >= repository.movesPageSize,
          currentMovesPage: nextPage,
        ));
      case ResultFailure():
        emit(currentState.copyWith());
    }
  }
}
