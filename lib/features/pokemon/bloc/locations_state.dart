import 'package:equatable/equatable.dart';

import '../../../../core/exceptions/failures.dart';
import '../domain/entities/pokemon_location.dart';
import '../domain/entities/region_map.dart';
import '../domain/value_objects/game_version.dart';

sealed class LocationsState extends Equatable {
  const LocationsState();
}

final class LocationsInitial extends LocationsState {
  const LocationsInitial();

  @override
  List<Object?> get props => [];
}

final class LocationsLoading extends LocationsState {
  const LocationsLoading();

  @override
  List<Object?> get props => [];
}

final class LocationsSuccess extends LocationsState {
  final List<PokemonLocation> locations;
  final GameVersion? selectedGameVersion;
  final List<RegionMap> regionMaps;

  const LocationsSuccess({
    required this.locations,
    this.selectedGameVersion,
    this.regionMaps = const [],
  });

  List<PokemonLocation> get locationsForSelectedVersion {
    if (selectedGameVersion == null) return locations;
    return locations
        .where((loc) => loc.gameVersion == selectedGameVersion?.name)
        .toList();
  }

  String get selectedRegion {
    return selectedGameVersion?.region ?? 'Unknown';
  }

  List<GameVersion> get locationGameVersions {
    return locations
        .map(
          (loc) => GameVersion(
            name: loc.gameVersion,
            displayName: GameVersion.formatDisplayName(loc.gameVersion),
          ),
        )
        .toSet()
        .toList()
      ..sort((a, b) => a.displayName.compareTo(b.displayName));
  }

  LocationsSuccess copyWith({
    List<PokemonLocation>? locations,
    GameVersion? Function()? selectedGameVersion,
    List<RegionMap>? Function()? regionMaps,
  }) {
    return LocationsSuccess(
      locations: locations ?? this.locations,
      selectedGameVersion: selectedGameVersion != null
          ? selectedGameVersion()
          : this.selectedGameVersion,
      regionMaps: regionMaps != null ? (regionMaps() ?? []) : this.regionMaps,
    );
  }

  @override
  List<Object?> get props => [locations, selectedGameVersion, regionMaps];
}

final class LocationsFailure extends LocationsState {
  final Failure failure;

  const LocationsFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
