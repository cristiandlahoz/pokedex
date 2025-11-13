import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../domain/usecases/get_pokemon_details.dart';
import 'pokemon_details_event.dart';
import 'pokemon_details_state.dart';

@injectable
class PokemonDetailsBloc extends Bloc<PokemonDetailsEvent, PokemonDetailsState> {
  final GetPokemonDetails getPokemonDetails;

  PokemonDetailsBloc({
    required this.getPokemonDetails,
  }) : super(const PokemonDetailsInitial()) {
    on<LoadPokemonDetails>(_onLoadPokemonDetails);
  }

  Future<void> _onLoadPokemonDetails(
    LoadPokemonDetails event,
    Emitter<PokemonDetailsState> emit,
  ) async {
    emit(const PokemonDetailsLoading());

    final result = await getPokemonDetails(event.pokemonId);

    result.fold(
      (failure) => emit(PokemonDetailsError(failure)),
      (pokemon) => emit(PokemonDetailsLoaded(pokemon)),
    );
  }
}
