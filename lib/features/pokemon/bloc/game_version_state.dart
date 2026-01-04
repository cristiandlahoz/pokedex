import 'package:equatable/equatable.dart';

import '../domain/value_objects/game_version.dart';

sealed class GameVersionState extends Equatable {
  const GameVersionState();
}

final class GameVersionInitial extends GameVersionState {
  const GameVersionInitial();

  @override
  List<Object?> get props => [];
}

final class GameVersionSelectionState extends GameVersionState {
  final List<GameVersion> availableVersions;
  final GameVersion selectedVersion;

  const GameVersionSelectionState({
    required this.availableVersions,
    required this.selectedVersion,
  });

  @override
  List<Object?> get props => [availableVersions, selectedVersion];
}
