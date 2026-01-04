import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

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

    final selected = event.initialVersion ?? event.versions.first;
    emit(GameVersionSelectionState(
      availableVersions: event.versions,
      selectedVersion: selected,
    ));
  }

  void _onGameVersionChanged(
    GameVersionChanged event,
    Emitter<GameVersionState> emit,
  ) {
    final currentState = state;
    if (currentState is! GameVersionSelectionState) return;

    emit(GameVersionSelectionState(
      availableVersions: currentState.availableVersions,
      selectedVersion: event.version,
    ));
  }
}
