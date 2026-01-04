import 'package:equatable/equatable.dart';

import '../../../core/exceptions/failures.dart';
import '../domain/entities/pokemon.dart';
import '../domain/entities/trivia_player.dart';
import '../domain/entities/trivia_question.dart';

sealed class TriviaState extends Equatable {
  const TriviaState();

  @override
  List<Object?> get props => [];
}

final class TriviaIdle extends TriviaState {
  final TriviaPlayer? currentPlayer;
  final int selectedLevel;

  const TriviaIdle({this.currentPlayer, this.selectedLevel = 1});

  @override
  List<Object?> get props => [currentPlayer, selectedLevel];
}

final class TriviaLoading extends TriviaState {
  const TriviaLoading();
}

final class TriviaQuestionActive extends TriviaState {
  final TriviaQuestion question;
  final int timeRemaining;

  const TriviaQuestionActive({
    required this.question,
    required this.timeRemaining,
  });

  @override
  List<Object?> get props => [question, timeRemaining];
}

final class TriviaAnswerRevealed extends TriviaState {
  final TriviaQuestion question;
  final Pokemon? userAnswer;
  final bool isCorrect;
  final int pointsEarned;

  const TriviaAnswerRevealed({
    required this.question,
    this.userAnswer,
    required this.isCorrect,
    required this.pointsEarned,
  });

  @override
  List<Object?> get props => [question, userAnswer, isCorrect, pointsEarned];
}

final class TriviaTimedOut extends TriviaState {
  final TriviaQuestion question;

  const TriviaTimedOut({required this.question});

  @override
  List<Object?> get props => [question];
}

final class TriviaStatsLoaded extends TriviaState {
  final TriviaPlayer player;

  const TriviaStatsLoaded({required this.player});

  @override
  List<Object?> get props => [player];
}

final class TriviaFailure extends TriviaState {
  final Failure failure;

  const TriviaFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}
