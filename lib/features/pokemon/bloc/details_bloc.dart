import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../core/utils/result.dart';
import '../domain/entities/pokemon_details.dart';
import '../domain/repositories/pokemon_repository.dart';
import '../domain/value_objects/game_version.dart';
import 'details_event.dart';
import 'details_state.dart';

@injectable
class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  final PokemonRepository repository;

  DetailsBloc({required this.repository}) : super(const DetailsInitial()) {
    on<DetailsLoadRequested>(_onDetailsLoadRequested);
    on<DetailsGameVersionSelected>(_onDetailsGameVersionSelected);
    on<DetailsShinyToggled>(_onDetailsShinyToggled);
  }

  Future<void> _onDetailsLoadRequested(
    DetailsLoadRequested event,
    Emitter<DetailsState> emit,
  ) async {
    emit(const DetailsLoading());

    final result = await repository.getPokemonDetails(event.pokemonId);

    switch (result) {
      case Success(:final data):
        final allVersions = GameVersion.allVersions;
        final firstVersion = allVersions.isNotEmpty ? allVersions.first : null;

        emit(DetailsSuccess(data, selectedGameVersion: firstVersion));
      case ResultFailure(:final failure):
        emit(DetailsFailure(failure));
    }
  }

  Future<void> _onDetailsGameVersionSelected(
    DetailsGameVersionSelected event,
    Emitter<DetailsState> emit,
  ) async {
    if (state is! DetailsSuccess) return;

    final currentState = state as DetailsSuccess;
    emit(currentState.copyWith(selectedGameVersion: event.version));
  }

  void _onDetailsShinyToggled(
    DetailsShinyToggled event,
    Emitter<DetailsState> emit,
  ) {
    if (state is! DetailsSuccess) return;

    final currentState = state as DetailsSuccess;
    emit(currentState.copyWith(isShiny: !currentState.isShiny));
  }
}
