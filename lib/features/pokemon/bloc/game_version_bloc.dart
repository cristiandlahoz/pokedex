import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../domain/value_objects/game_version.dart';
import 'game_version_event.dart';
import 'game_version_state.dart';

@injectable
class GameVersionBloc extends Bloc<GameVersionEvent, GameVersionState> {
  GameVersionBloc() : super(const GameVersionInitial()) {
    on<GameVersionsLoaded>(_onGameVersionsLoaded);
    on<GameVersionChanged>(_onGameVersionChanged);
  }

  void _onGameVersionsLoaded(
    GameVersionsLoaded event,
    Emitter<GameVersionState> emit,
  ) {
    if (event.versions.isEmpty) {
      emit(const GameVersionInitial());
      return;
    }

    final uniqueVersions = <String, GameVersion>{};
    for (final version in event.versions) {
      uniqueVersions[version.name] = version;
    }
    final deduplicatedVersions = uniqueVersions.values.toList();

    final selected = event.initialVersion != null
        ? (uniqueVersions[event.initialVersion!.name] ?? deduplicatedVersions.first)
        : deduplicatedVersions.first;
    emit(
      GameVersionSelectionState(
        availableVersions: deduplicatedVersions,
        selectedVersion: selected,
      ),
    );
  }

  void _onGameVersionChanged(
    GameVersionChanged event,
    Emitter<GameVersionState> emit,
  ) {
    final currentState = state;
    if (currentState is! GameVersionSelectionState) return;

    emit(
      GameVersionSelectionState(
        availableVersions: currentState.availableVersions,
        selectedVersion: event.version,
      ),
    );
  }
}
