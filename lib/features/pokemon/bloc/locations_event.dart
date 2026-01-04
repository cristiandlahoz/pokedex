import 'package:equatable/equatable.dart';

import '../domain/value_objects/game_version.dart';

sealed class LocationsEvent extends Equatable {
  const LocationsEvent();
}

final class LocationsLoadRequested extends LocationsEvent {
  final int pokemonId;

  const LocationsLoadRequested({required this.pokemonId});

  @override
  List<Object?> get props => [pokemonId];
}

final class GameVersionSelected extends LocationsEvent {
  final GameVersion version;

  const GameVersionSelected({required this.version});

  @override
  List<Object?> get props => [version];
}
