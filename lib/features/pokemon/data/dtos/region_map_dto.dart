import '../../domain/entities/region_map.dart';
import 'map_area_dto.dart';

class RegionMapDto {
  final String region;
  final String image;
  final List<MapAreaDto> locations;

  const RegionMapDto({
    required this.region,
    required this.image,
    required this.locations,
  });

  factory RegionMapDto.fromJson(Map<String, dynamic> json) {
    return RegionMapDto(
      region: json['region'] as String,
      image: json['image'] as String,
      locations: (json['locations'] as List)
          .map((loc) => MapAreaDto.fromJson(loc as Map<String, dynamic>))
          .toList(),
    );
  }

  RegionMap toDomain() => RegionMap(
    region: region,
    imagePath: image,
    areas: locations.map((dto) => dto.toDomain()).toList(),
  );
}
