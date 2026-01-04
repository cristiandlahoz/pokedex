import 'package:injectable/injectable.dart';

import '../../../../core/utils/result.dart';
import '../entities/pokemon_location.dart';
import '../entities/region_map.dart';
import '../repositories/pokemon_repository.dart';
import 'location_matcher.dart';
import 'region_detector.dart';

@injectable
class LocationMapService {
  final PokemonRepository repository;
  final LocationMatcher locationMatcher;

  const LocationMapService({
    required this.repository,
    required this.locationMatcher,
  });

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
