import 'package:equatable/equatable.dart';

import '../domain/value_objects/game_version.dart';

sealed class DetailsEvent extends Equatable {
  const DetailsEvent();

  @override
  List<Object?> get props => [];
}

class DetailsLoadRequested extends DetailsEvent {
  final int pokemonId;

  const DetailsLoadRequested(this.pokemonId);

  @override
  List<Object?> get props => [pokemonId];
}

class DetailsLoadMoreMovesRequested extends DetailsEvent {
  final int pokemonId;

  const DetailsLoadMoreMovesRequested(this.pokemonId);

  @override
  List<Object?> get props => [pokemonId];
}

class DetailsGameVersionSelected extends DetailsEvent {
  final GameVersion version;

  const DetailsGameVersionSelected({required this.version});

  @override
  List<Object?> get props => [version];
}
