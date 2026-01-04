import '../../domain/entities/map_area.dart';

class MapAreaDto {
  final String name;
  final String shape;
  final List<double> coords;

  const MapAreaDto({
    required this.name,
    required this.shape,
    required this.coords,
  });

  factory MapAreaDto.fromJson(Map<String, dynamic> json) {
    return MapAreaDto(
      name: json['name'] as String,
      shape: json['shape'] as String,
      coords: (json['coords'] as List)
          .map((c) => (c as num).toDouble())
          .toList(),
    );
  }

  MapArea toDomain() => MapArea(
        name: name,
        shape: AreaShape.fromString(shape),
        coords: coords,
      );
}
