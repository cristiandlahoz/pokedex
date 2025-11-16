import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../domain/repositories/pokemon_repository.dart';
import 'details_event.dart';
import 'details_state.dart';

@injectable
class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final PokemonRepository repository;

  DetailsBloc({
    required this.repository,
  }) : super(const DetailsInitial()) {
    on<DetailsLoadRequested>(_onDetailsLoadRequested);
  }

  Future<void> _onDetailsLoadRequested(
    DetailsLoadRequested event,
    Emitter<DetailsState> emit,
  ) async {
    emit(const DetailsLoading());

    final result = await repository.getPokemonDetails(event.pokemonId);

    result.fold(
      (failure) => emit(DetailsFailure(failure)),
      (pokemon) => emit(DetailsSuccess(pokemon)),
    );
  }
}
