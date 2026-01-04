import '../../../domain/entities/pokemon_stat.dart';

class StatsParser {
  static List<PokemonStat> parse(dynamic statsData) {
    if (statsData == null || statsData is! List) return [];

    final stats = <PokemonStat>[];

    for (final statData in statsData) {
      if (statData is! Map) continue;
      if (statData['stat'] == null) continue;
      if (statData['stat']['name'] == null) continue;
      if (statData['base_stat'] == null) continue;

      stats.add(
        PokemonStat(
          name: statData['stat']['name'] as String,
          baseStat: statData['base_stat'] as int,
          effort: statData['effort'] as int? ?? 0,
        ),
      );
    }

    return stats;
  }
}
