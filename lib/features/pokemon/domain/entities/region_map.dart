import 'package:equatable/equatable.dart';

import 'map_area.dart';

class RegionMap extends Equatable {
  final String region;
  final String imagePath;
  final List<MapArea> areas;
  final List<String> highlightedAreas;

  const RegionMap({
    required this.region,
    required this.imagePath,
    required this.areas,
    this.highlightedAreas = const [],
  });

  List<MapArea> getAreasByNames(List<String> names) {
    return areas.where((area) => names.contains(area.name)).toList();
  }

  RegionMap copyWith({
    String? region,
    String? imagePath,
    List<MapArea>? areas,
    List<String>? highlightedAreas,
  }) {
    return RegionMap(
      region: region ?? this.region,
      imagePath: imagePath ?? this.imagePath,
      areas: areas ?? this.areas,
      highlightedAreas: highlightedAreas ?? this.highlightedAreas,
    );
  }

  @override
  List<Object?> get props => [region, imagePath, areas, highlightedAreas];
}
