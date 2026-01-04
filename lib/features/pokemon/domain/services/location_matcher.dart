import 'package:injectable/injectable.dart';

import '../entities/pokemon_location.dart';
import '../entities/region_map.dart';
import 'location_name_normalizer.dart';

@injectable
class LocationMatcher {
  List<String> matchLocationsToMap({
    required List<PokemonLocation> locations,
    required RegionMap regionMap,
  }) {
    final coordinateNames = regionMap.areas.map((area) => area.name).toList();
    final matchedAreas = <String>{};

    for (final location in locations) {
      final matchedName = LocationNameNormalizer.findMatchInCoordinates(
        location.areaName,
        coordinateNames,
      );

      if (matchedName != null) {
        matchedAreas.add(matchedName);
      }
    }

    return matchedAreas.toList();
  }
}
