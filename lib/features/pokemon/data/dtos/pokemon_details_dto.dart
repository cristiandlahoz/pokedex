import '../../domain/entities/pokemon_ability.dart';
import '../../domain/entities/pokemon_details.dart';
import '../../domain/entities/pokemon_move.dart';
import '../../domain/entities/pokemon_stat.dart';
import '../../domain/entities/pokemon_types.dart';
import '../../domain/entities/type_defense_info.dart';
import 'pokemon_dto.dart';

class PokemonDetailsDto extends PokemonDto {
  final String? genus;
  final String? description;
  final List<PokemonAbility> abilities;
  final List<PokemonStat> stats;
  final List<PokemonMove> moves;
  final int? baseExperience;
  final int? captureRate;
  final int? baseHappiness;
  final String? growthRate;
  final String? eggGroup;
  final int? genderRatio;
  final List<String> eggGroups;
  final List<TypeDefenseInfo> typeDefenses;

  const PokemonDetailsDto({
    required super.id,
    required super.name,
    required super.types,
    super.imageUrl,
    super.height,
    super.weight,
    this.genus,
    this.description,
    this.abilities = const [],
    this.stats = const [],
    this.moves = const [],
    this.baseExperience,
    this.captureRate,
    this.baseHappiness,
    this.growthRate,
    this.eggGroup,
    this.genderRatio,
    this.eggGroups = const [],
    this.typeDefenses = const [],
  });

  PokemonDetails toDomainDetails() {
    return PokemonDetails(
      id: id,
      name: name,
      types: types,
      imageUrl: imageUrl,
      height: height,
      weight: weight,
      genus: genus,
      description: description,
      abilities: abilities,
      stats: stats,
      moves: moves,
      baseExperience: baseExperience,
      captureRate: captureRate,
      baseHappiness: baseHappiness,
      growthRate: growthRate,
      eggGroup: eggGroup,
      genderRatio: genderRatio,
      eggGroups: eggGroups,
      typeDefenses: typeDefenses,
    );
  }

  factory PokemonDetailsDto.fromJson(Map<String, dynamic> json) {
    final baseDto = PokemonDto.fromJson(json);

    final species = json['pokemonspecy'] as Map<String, dynamic>?;
    String? genus;
    String? description;
    if (species != null) {
      final genera = species['pokemonspeciesnames'] as List?;
      if (genera != null && genera.isNotEmpty) {
        genus = genera[0]['genus'] as String?;
      }

      final descriptions = species['pokemonspeciesflavortexts'] as List?;
      if (descriptions != null && descriptions.isNotEmpty) {
        description = (descriptions[0]['flavor_text'] as String?)
            ?.replaceAll('\n', ' ')
            .replaceAll('\f', ' ');
      }
    }

    final abilities = <PokemonAbility>[];
    if (json['pokemonabilities'] != null) {
      for (final abilityData in json['pokemonabilities'] as List) {
        if (abilityData['ability'] != null &&
            abilityData['ability']['name'] != null) {
          abilities.add(
            PokemonAbility(
              id: abilityData['ability']['id'] as int,
              name: abilityData['ability']['name'] as String,
              isHidden: abilityData['is_hidden'] as bool? ?? false,
            ),
          );
        }
      }
    }

    final stats = <PokemonStat>[];
    if (json['pokemonstats'] != null) {
      for (final statData in json['pokemonstats'] as List) {
        if (statData['stat'] != null && statData['stat']['name'] != null) {
          stats.add(
            PokemonStat(
              name: statData['stat']['name'] as String,
              baseStat: statData['base_stat'] as int,
              effort: statData['effort'] as int? ?? 0,
            ),
          );
        }
      }
    }

    final moves = <PokemonMove>[];
    if (json['pokemonmoves'] != null) {
      for (final moveData in json['pokemonmoves'] as List) {
        if (moveData['move'] != null && moveData['move']['name'] != null) {
          moves.add(
            PokemonMove(
              name: moveData['move']['name'] as String,
            ),
          );
        }
      }
    }

    final List<String> eggGroups = [];
    if (species != null && species['pokemonegggroups'] != null) {
      for (final eggGroupData in species['pokemonegggroups'] as List) {
        if (eggGroupData['egggroup'] != null &&
            eggGroupData['egggroup']['name'] != null) {
          eggGroups.add(eggGroupData['egggroup']['name'] as String);
        }
      }
    }

    final typeDefenses = _parseTypeDefenses(json, baseDto.types);

    return PokemonDetailsDto(
      id: baseDto.id,
      name: baseDto.name,
      types: baseDto.types,
      imageUrl: baseDto.imageUrl,
      height: baseDto.height,
      weight: baseDto.weight,
      genus: genus,
      description: description,
      abilities: abilities,
      stats: stats,
      moves: moves,
      baseExperience: json['base_experience'] as int?,
      captureRate: species?['capture_rate'] as int?,
      baseHappiness: species?['base_happiness'] as int?,
      growthRate: species?['growthrate']?['name'] as String?,
      eggGroup: eggGroups.isNotEmpty ? eggGroups.first : null,
      genderRatio: species?['gender_rate'] as int?,
      eggGroups: eggGroups,
      typeDefenses: typeDefenses,
    );
  }

  static List<TypeDefenseInfo> _parseTypeDefenses(
    Map<String, dynamic> json,
    List<PokemonTypes> pokemonTypes,
  ) {
    return [];
  }
}
