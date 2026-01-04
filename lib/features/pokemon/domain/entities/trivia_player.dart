import 'package:equatable/equatable.dart';

import 'trivia_level_stats.dart';

/// Represents a trivia player with statistics
class TriviaPlayer extends Equatable {
  final String name;
  final DateTime createdAt;
  final DateTime lastPlayedAt;
  final Map<int, TriviaLevelStats> levelStats;

  const TriviaPlayer({
    required this.name,
    required this.createdAt,
    required this.lastPlayedAt,
    this.levelStats = const {},
  });

  /// Gets total correct answers across all levels
  int getTotalCorrect() {
    return levelStats.values.fold(
      0,
      (sum, stats) => sum + stats.correctAnswers,
    );
  }

  /// Gets total wrong answers across all levels
  int getTotalWrong() {
    return levelStats.values.fold(0, (sum, stats) => sum + stats.wrongAnswers);
  }

  /// Gets overall accuracy percentage (0-100) across all levels
  double getOverallAccuracy() {
    final total = getTotalCorrect() + getTotalWrong();
    if (total == 0) return 0.0;
    return (getTotalCorrect() / total) * 100;
  }

  /// Gets statistics for a specific level
  TriviaLevelStats getStatsForLevel(int level) {
    return levelStats[level] ?? TriviaLevelStats(level: level);
  }

  /// Creates a copy with updated values
  TriviaPlayer copyWith({
    String? name,
    DateTime? createdAt,
    DateTime? lastPlayedAt,
    Map<int, TriviaLevelStats>? levelStats,
  }) {
    return TriviaPlayer(
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      lastPlayedAt: lastPlayedAt ?? this.lastPlayedAt,
      levelStats: levelStats ?? this.levelStats,
    );
  }

  /// Updates stats for a specific level
  TriviaPlayer updateLevelStats(int level, TriviaLevelStats stats) {
    final updatedStats = Map<int, TriviaLevelStats>.from(levelStats);
    updatedStats[level] = stats;
    return copyWith(levelStats: updatedStats, lastPlayedAt: DateTime.now());
  }

  @override
  List<Object?> get props => [name, createdAt, lastPlayedAt, levelStats];
}
