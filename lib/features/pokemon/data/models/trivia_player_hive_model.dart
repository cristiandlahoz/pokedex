import 'package:hive/hive.dart';

import '../../domain/entities/trivia_player.dart';
import '../../domain/entities/trivia_level_stats.dart';
import 'trivia_level_stats_hive_model.dart';

part 'trivia_player_hive_model.g.dart';

@HiveType(typeId: 9)
class TriviaPlayerHiveModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final DateTime createdAt;

  @HiveField(2)
  final DateTime lastPlayedAt;

  @HiveField(3)
  final Map<int, TriviaLevelStatsHiveModel> levelStats;

  TriviaPlayerHiveModel({
    required this.name,
    required this.createdAt,
    required this.lastPlayedAt,
    this.levelStats = const {},
  });

  factory TriviaPlayerHiveModel.fromDomain(TriviaPlayer player) {
    final hiveStats = <int, TriviaLevelStatsHiveModel>{};
    player.levelStats.forEach((level, stats) {
      hiveStats[level] = TriviaLevelStatsHiveModel.fromDomain(stats);
    });

    return TriviaPlayerHiveModel(
      name: player.name,
      createdAt: player.createdAt,
      lastPlayedAt: player.lastPlayedAt,
      levelStats: hiveStats,
    );
  }

  TriviaPlayer toDomain() {
    final domainStats = <int, TriviaLevelStats>{};
    levelStats.forEach((level, stats) {
      domainStats[level] = stats.toDomain();
    });

    return TriviaPlayer(
      name: name,
      createdAt: createdAt,
      lastPlayedAt: lastPlayedAt,
      levelStats: domainStats,
    );
  }
}
