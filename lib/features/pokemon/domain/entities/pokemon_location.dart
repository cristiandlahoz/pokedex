import 'package:equatable/equatable.dart';

class PokemonLocation extends Equatable {
  final String locationName;
  final String areaName;
  final String region;
  final String gameVersion;
  final int minLevel;
  final int maxLevel;

  const PokemonLocation({
    required this.locationName,
    required this.areaName,
    required this.region,
    required this.gameVersion,
    required this.minLevel,
    required this.maxLevel,
  });

  @override
  List<Object?> get props => [
    locationName,
    areaName,
    region,
    gameVersion,
    minLevel,
    maxLevel,
  ];
}
