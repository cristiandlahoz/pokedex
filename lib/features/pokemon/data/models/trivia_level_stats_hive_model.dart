import 'package:hive/hive.dart';

import '../../domain/entities/trivia_level_stats.dart';

part 'trivia_level_stats_hive_model.g.dart';

@HiveType(typeId: 10)
class TriviaLevelStatsHiveModel extends HiveObject {
  @HiveField(0)
  final int level;

  @HiveField(1)
  final int correctAnswers;

  @HiveField(2)
  final int wrongAnswers;

  TriviaLevelStatsHiveModel({
    required this.level,
    this.correctAnswers = 0,
    this.wrongAnswers = 0,
  });

  factory TriviaLevelStatsHiveModel.fromDomain(TriviaLevelStats stats) {
    return TriviaLevelStatsHiveModel(
      level: stats.level,
      correctAnswers: stats.correctAnswers,
      wrongAnswers: stats.wrongAnswers,
    );
  }

  TriviaLevelStats toDomain() {
    return TriviaLevelStats(
      level: level,
      correctAnswers: correctAnswers,
      wrongAnswers: wrongAnswers,
    );
  }
}
