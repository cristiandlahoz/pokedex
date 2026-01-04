import 'package:equatable/equatable.dart';

import '../domain/value_objects/game_version.dart';

sealed class GameVersionEvent extends Equatable {
  const GameVersionEvent();
}

final class GameVersionsLoaded extends GameVersionEvent {
  final List<GameVersion> versions;
  final GameVersion? initialVersion;

  const GameVersionsLoaded({required this.versions, this.initialVersion});

  @override
  List<Object?> get props => [versions, initialVersion];
}

final class GameVersionChanged extends GameVersionEvent {
  final GameVersion version;

  const GameVersionChanged({required this.version});

  @override
  List<Object?> get props => [version];
}
