import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex/features/pokemon/domain/repositories/locations_repository.dart';

import '../../../../core/utils/result.dart';
import '../domain/entities/pokemon_location.dart';
import '../domain/entities/region_map.dart';
import '../domain/services/location_matcher.dart';
import '../domain/services/region_detector.dart';
import '../domain/value_objects/game_version.dart';
import 'locations_event.dart';
import 'locations_state.dart';

@injectable
class LocationsBloc extends Bloc<LocationsEvent, LocationsState> {
  final LocationsRepository repository;
  final LocationMatcher locationMatcher;

  LocationsBloc({required this.repository, required this.locationMatcher})
    : super(const LocationsInitial()) {
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
          emit(const LocationsSuccess(locations: []));
          return;
        }

        final firstVersionName = data.first.gameVersion;
        final firstVersion = GameVersion(
          name: firstVersionName,
          displayName: GameVersion.formatDisplayName(firstVersionName),
        );

        emit(
          LocationsSuccess(locations: data, selectedGameVersion: firstVersion),
        );

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

    emit(
      currentState.copyWith(
        selectedGameVersion: () => event.version,
        regionMaps: () => const [],
      ),
    );

    await _loadAndMatchRegionMap(emit);
  }

  Future<void> _loadAndMatchRegionMap(Emitter<LocationsState> emit) async {
    final currentState = state;
    if (currentState is! LocationsSuccess) return;

    final locationsForVersion = currentState.locationsForSelectedVersion;
    final loadedMaps = await loadAndMatchMapsForLocations(
      locations: locationsForVersion,
      fallbackRegion: currentState.selectedRegion,
    );

    emit(currentState.copyWith(regionMaps: () => loadedMaps));
  }

  Future<List<RegionMap>> loadAndMatchMapsForLocations({
    required List<PokemonLocation> locations,
    required String fallbackRegion,
  }) async {
    if (locations.isEmpty) return const [];

    final locationNames = locations.map((loc) => loc.areaName).toList();
    final detectedRegions = RegionDetector.detectRegionsForLocations(
      locationNames,
    );

    if (detectedRegions.isEmpty) {
      detectedRegions.add(fallbackRegion.toLowerCase());
    }

    final loadedMaps = <RegionMap>[];

    for (final region in detectedRegions) {
      final result = await repository.loadRegionMap(region);

      switch (result) {
        case Success(:final data):
          final highlightedAreas = locationMatcher.matchLocationsToMap(
            locations: locations,
            regionMap: data,
          );

          if (highlightedAreas.isNotEmpty) {
            final updatedMap = data.copyWith(
              highlightedAreas: highlightedAreas,
            );
            loadedMaps.add(updatedMap);
          }

        case ResultFailure():
          continue;
      }
    }

    return loadedMaps;
  }
}
