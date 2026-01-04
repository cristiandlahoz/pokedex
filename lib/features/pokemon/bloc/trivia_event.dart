import 'package:equatable/equatable.dart';

import '../domain/entities/pokemon.dart';

sealed class TriviaEvent extends Equatable {
  const TriviaEvent();

  @override
  List<Object?> get props => [];
}

final class TriviaStarted extends TriviaEvent {
  final int level;

  const TriviaStarted({required this.level});

  @override
  List<Object?> get props => [level];
}

final class TriviaLevelChanged extends TriviaEvent {
  final int level;

  const TriviaLevelChanged({required this.level});

  @override
  List<Object?> get props => [level];
}

final class TriviaAnswerSelected extends TriviaEvent {
  final Pokemon selectedPokemon;

  const TriviaAnswerSelected({required this.selectedPokemon});

  @override
  List<Object?> get props => [selectedPokemon];
}

final class TriviaTimeout extends TriviaEvent {
  const TriviaTimeout();
}

final class TriviaTimerTicked extends TriviaEvent {
  final int secondsRemaining;

  const TriviaTimerTicked({required this.secondsRemaining});

  @override
  List<Object?> get props => [secondsRemaining];
}

final class TriviaNextQuestionRequested extends TriviaEvent {
  const TriviaNextQuestionRequested();
}

final class TriviaPlayerChanged extends TriviaEvent {
  final String playerName;

  const TriviaPlayerChanged({required this.playerName});

  @override
  List<Object?> get props => [playerName];
}

final class TriviaPlayerAdded extends TriviaEvent {
  final String playerName;

  const TriviaPlayerAdded({required this.playerName});

  @override
  List<Object?> get props => [playerName];
}

final class TriviaStatsRequested extends TriviaEvent {
  const TriviaStatsRequested();
}

final class TriviaBackToMenu extends TriviaEvent {
  const TriviaBackToMenu();
}
