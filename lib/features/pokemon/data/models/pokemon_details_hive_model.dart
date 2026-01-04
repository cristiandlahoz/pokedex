import 'package:hive/hive.dart';

import '../../domain/entities/pokemon_details.dart';
import '../../domain/entities/pokemon_types.dart';
import 'evolution_chain_hive_model.dart';
import 'pokemon_ability_hive_model.dart';
import 'pokemon_move_hive_model.dart';
import 'pokemon_stat_hive_model.dart';
import 'type_defense_info_hive_model.dart';

part 'pokemon_details_hive_model.g.dart';

@HiveType(typeId: 1)
class PokemonDetailsHiveModel extends HiveObject {
  // Pokemon base fields
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final List<int> typeIndices;

  @HiveField(3)
  final String? imageUrl;

  @HiveField(4)
  final int? height;

  @HiveField(5)
  final int? weight;

  // PokemonDetails extended fields
  @HiveField(6)
  final String? genus;

  @HiveField(7)
  final String? description;

  @HiveField(8)
  final List<PokemonAbilityHiveModel> abilities;

  @HiveField(9)
  final List<PokemonStatHiveModel> stats;

  @HiveField(10)
  final List<PokemonMoveHiveModel> moves;

  @HiveField(11)
  final int? baseExperience;

  @HiveField(12)
  final int? captureRate;

  @HiveField(13)
  final int? baseHappiness;

  @HiveField(14)
  final String? growthRate;

  @HiveField(15)
  final String? eggGroup;

  @HiveField(16)
  final int? genderRatio;

  @HiveField(17)
  final List<String> eggGroups;

  @HiveField(18)
  final List<TypeDefenseInfoHiveModel> typeDefenses;

  @HiveField(19)
  final List<TypeDefenseInfoHiveModel> typeOffenses;

  @HiveField(20)
  final EvolutionChainHiveModel? evolutionChain;

  PokemonDetailsHiveModel({
    required this.id,
    required this.name,
    required this.typeIndices,
    this.imageUrl,
    this.height,
    this.weight,
    this.genus,
    this.description,
    required this.abilities,
    required this.stats,
    required this.moves,
    this.baseExperience,
    this.captureRate,
    this.baseHappiness,
    this.growthRate,
    this.eggGroup,
    this.genderRatio,
    required this.eggGroups,
    required this.typeDefenses,
    required this.typeOffenses,
    this.evolutionChain,
  });

  factory PokemonDetailsHiveModel.fromDomain(PokemonDetails details) {
    return PokemonDetailsHiveModel(
      id: details.id,
      name: details.name,
      typeIndices: details.types.map((t) => t.index).toList(),
      imageUrl: details.imageUrl,
      height: details.height,
      weight: details.weight,
      genus: details.genus,
      description: details.description,
      abilities: details.abilities
          .map((a) => PokemonAbilityHiveModel.fromDomain(a))
          .toList(),
      stats: details.stats
          .map((s) => PokemonStatHiveModel.fromDomain(s))
          .toList(),
      moves: details.moves
          .map((m) => PokemonMoveHiveModel.fromDomain(m))
          .toList(),
      baseExperience: details.baseExperience,
      captureRate: details.captureRate,
      baseHappiness: details.baseHappiness,
      growthRate: details.growthRate,
      eggGroup: details.eggGroup,
      genderRatio: details.genderRatio,
      eggGroups: details.eggGroups,
      typeDefenses: details.typeDefenses
          .map((t) => TypeDefenseInfoHiveModel.fromDomain(t))
          .toList(),
      typeOffenses: details.typeOffenses
          .map((t) => TypeDefenseInfoHiveModel.fromDomain(t))
          .toList(),
      evolutionChain: details.evolutionChain != null
          ? EvolutionChainHiveModel.fromDomain(details.evolutionChain!)
          : null,
    );
  }

  PokemonDetails toDomain() {
    return PokemonDetails(
      id: id,
      name: name,
      types: typeIndices.map((i) => PokemonTypes.values[i]).toList(),
      imageUrl: imageUrl,
      height: height,
      weight: weight,
      genus: genus,
      description: description,
      abilities: abilities.map((a) => a.toDomain()).toList(),
      stats: stats.map((s) => s.toDomain()).toList(),
      moves: moves.map((m) => m.toDomain()).toList(),
      baseExperience: baseExperience,
      captureRate: captureRate,
      baseHappiness: baseHappiness,
      growthRate: growthRate,
      eggGroup: eggGroup,
      genderRatio: genderRatio,
      eggGroups: eggGroups,
      typeDefenses: typeDefenses.map((t) => t.toDomain()).toList(),
      typeOffenses: typeOffenses.map((t) => t.toDomain()).toList(),
      evolutionChain: evolutionChain?.toDomain(),
    );
  }
}
