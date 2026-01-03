import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/utils/result.dart';
import '../domain/repositories/pokemon_repository.dart';
import '../domain/services/location_map_service.dart';
import '../domain/value_objects/game_version.dart';
import 'locations_event.dart';
import 'locations_state.dart';

@injectable
class LocationsBloc extends Bloc<LocationsEvent, LocationsState> {
  final PokemonRepository repository;
  final LocationMapService locationMapService;

  LocationsBloc({
    required this.repository,
    required this.locationMapService,
  }) : super(const LocationsInitial()) {
    on<LocationsLoadRequested>(_onLoadRequested);
    on<GameVersionSelected>(_onGameVersionSelected);
  }

  Future<void> _onLoadRequested(
    LocationsLoadRequested event,
    Emitter<LocationsState> emit,
  ) async {
    emit(const LocationsLoading());

    final result = await repository.getPokemonLocations(event.pokemonId);

    switch (result) {
      case Success(:final data):
        if (data.isEmpty) {
          emit(const LocationsSuccess(
            locations: [],
          ));
          return;
        }

        final firstVersionName = data.first.gameVersion;
        final firstVersion = GameVersion(
          name: firstVersionName,
          displayName: GameVersion.formatDisplayName(firstVersionName),
        );
        
        emit(LocationsSuccess(
          locations: data,
          selectedGameVersion: firstVersion,
        ));

        await _loadAndMatchRegionMap(emit);

      case ResultFailure(:final failure):
        emit(LocationsFailure(failure: failure));
    }
  }

  Future<void> _onGameVersionSelected(
    GameVersionSelected event,
    Emitter<LocationsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! LocationsSuccess) return;

    emit(currentState.copyWith(
      selectedGameVersion: () => event.version,
      regionMaps: () => const [],
    ));

    await _loadAndMatchRegionMap(emit);
  }

  Future<void> _loadAndMatchRegionMap(Emitter<LocationsState> emit) async {
    final currentState = state;
    if (currentState is! LocationsSuccess) return;

    final locationsForVersion = currentState.locationsForSelectedVersion;
    final loadedMaps = await locationMapService.loadAndMatchMapsForLocations(
      locations: locationsForVersion,
      fallbackRegion: currentState.selectedRegion,
    );

    emit(currentState.copyWith(regionMaps: () => loadedMaps));
  }
}
