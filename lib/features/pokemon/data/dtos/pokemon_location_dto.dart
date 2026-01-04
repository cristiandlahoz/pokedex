import '../../../../core/utils/string_utils.dart';
import '../../domain/entities/pokemon_location.dart';

class PokemonLocationDto {
  final String locationName;
  final String areaName;
  final String region;
  final String gameVersion;
  final int minLevel;
  final int maxLevel;

  const PokemonLocationDto({
    required this.locationName,
    required this.areaName,
    required this.region,
    required this.gameVersion,
    required this.minLevel,
    required this.maxLevel,
  });

  factory PokemonLocationDto.fromJson(Map<String, dynamic> json) {
    final locationArea = json['locationarea'] as Map<String, dynamic>?;
    final location = locationArea?['location'] as Map<String, dynamic>?;
    final region = location?['region'] as Map<String, dynamic>?;
    final version = json['version'] as Map<String, dynamic>?;
    final versionGroup = version?['versiongroup'] as Map<String, dynamic>?;

    return PokemonLocationDto(
      locationName: location?['name'] as String? ?? 'Unknown',
      areaName: locationArea?['name'] as String? ?? 'Unknown',
      region: StringUtils.capitalizeFirst(
        region?['name'] as String? ?? 'Unknown',
      ),
      gameVersion: versionGroup?['name'] as String? ?? 'unknown',
      minLevel: json['min_level'] as int? ?? 0,
      maxLevel: json['max_level'] as int? ?? 0,
    );
  }

  PokemonLocation toDomain() => PokemonLocation(
    locationName: locationName,
    areaName: areaName,
    region: region,
    gameVersion: gameVersion,
    minLevel: minLevel,
    maxLevel: maxLevel,
  );
}
