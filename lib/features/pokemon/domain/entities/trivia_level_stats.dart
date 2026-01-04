import 'package:equatable/equatable.dart';

/// Represents per-level statistics for a trivia player
class TriviaLevelStats extends Equatable {
  final int level;
  final int correctAnswers;
  final int wrongAnswers;

  const TriviaLevelStats({
    required this.level,
    this.correctAnswers = 0,
    this.wrongAnswers = 0,
  });

  /// Total number of attempts for this level
  int get totalAttempts => correctAnswers + wrongAnswers;

  /// Accuracy percentage (0-100) for this level
  double get accuracy {
    if (totalAttempts == 0) return 0.0;
    return (correctAnswers / totalAttempts) * 100;
  }

  /// Creates a copy with updated values
  TriviaLevelStats copyWith({
    int? level,
    int? correctAnswers,
    int? wrongAnswers,
  }) {
    return TriviaLevelStats(
      level: level ?? this.level,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      wrongAnswers: wrongAnswers ?? this.wrongAnswers,
    );
  }

  /// Increments correct answer count
  TriviaLevelStats incrementCorrect() {
    return copyWith(correctAnswers: correctAnswers + 1);
  }

  /// Increments wrong answer count
  TriviaLevelStats incrementWrong() {
    return copyWith(wrongAnswers: wrongAnswers + 1);
  }

  @override
  List<Object?> get props => [level, correctAnswers, wrongAnswers];
}
