import 'package:hive/hive.dart';

import '../../domain/entities/pokemon_stat.dart';

part 'pokemon_stat_hive_model.g.dart';

@HiveType(typeId: 3)
class PokemonStatHiveModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final int baseStat;

  @HiveField(2)
  final int effort;

  PokemonStatHiveModel({
    required this.name,
    required this.baseStat,
    required this.effort,
  });

  factory PokemonStatHiveModel.fromDomain(PokemonStat stat) {
    return PokemonStatHiveModel(
      name: stat.name,
      baseStat: stat.baseStat,
      effort: stat.effort,
    );
  }

  PokemonStat toDomain() {
    return PokemonStat(name: name, baseStat: baseStat, effort: effort);
  }
}
