import '../../../../core/constants/app.dart';
import '../../domain/entities/pokemon_ability.dart';
import '../../domain/entities/pokemon_details.dart';
import '../../domain/entities/pokemon_move.dart';
import '../../domain/entities/pokemon_stat.dart';
import '../../domain/entities/pokemon_types.dart';
import '../../domain/entities/type_defense_info.dart';
import 'list_item_dto.dart';
import 'parsers/abilities_parser.dart';
import 'parsers/egg_groups_parser.dart';
import 'parsers/moves_parser.dart';
import 'parsers/species_parser.dart';
import 'parsers/stats_parser.dart';

class DetailsDto extends ListItemDto {
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
  final List<TypeDefenseInfo> typeOffenses;

  const DetailsDto({
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
    this.typeOffenses = const [],
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
      typeOffenses: typeOffenses,
    );
  }

  factory DetailsDto.fromJson(Map<String, dynamic> json) {
    try {
      final baseDto = ListItemDto.fromJson(json);

      final species = SpeciesParser.parse(json['pokemonspecy']);
      final abilities = AbilitiesParser.parse(json['pokemonabilities']);
      final stats = StatsParser.parse(json['pokemonstats']);
      final moves = MovesParser.parse(json['pokemonmoves']);
      final eggGroups = EggGroupsParser.parse(json['pokemonspecy']);

      final typeDefenses = _parseTypeDefenses(json, baseDto.types);
      final typeOffenses = _parseTypeOffenses(json, baseDto.types);

      return DetailsDto(
        id: baseDto.id,
        name: baseDto.name,
        types: baseDto.types,
        imageUrl: baseDto.imageUrl,
        height: baseDto.height,
        weight: baseDto.weight,
        genus: species.genus,
        description: species.description,
        abilities: abilities,
        stats: stats,
        moves: moves,
        baseExperience: json['base_experience'] as int?,
        captureRate: species.captureRate,
        baseHappiness: species.baseHappiness,
        growthRate: species.growthRate,
        eggGroup: eggGroups.isNotEmpty ? eggGroups.first : null,
        genderRatio: species.genderRatio,
        eggGroups: eggGroups,
        typeDefenses: typeDefenses,
        typeOffenses: typeOffenses,
      );
    } catch (e) {
      rethrow;
    }
  }

  static List<TypeDefenseInfo> _parseTypeDefenses(
    Map<String, dynamic> json,
    List<PokemonTypes> pokemonTypes,
  ) {
    try {
      if (pokemonTypes.isEmpty) {
        return [];
      }

      final Map<PokemonTypes, double> effectivenessMap = {};

      final pokemonTypesData = json['pokemontypes'];

      if (pokemonTypesData == null) {
        return [];
      }

      if (pokemonTypesData is! List || pokemonTypesData.isEmpty) {
        return [];
      }

    final Map<int, List<Map<String, dynamic>>> typeEfficacyByDefendingType = {};
    final Map<PokemonTypes, int> typeToIdMap = {};

    for (final pokemonTypeData in pokemonTypesData) {
      final typeData = pokemonTypeData['type'] as Map<String, dynamic>?;
      if (typeData == null) continue;

      final targetTypeId = typeData['id'] as int?;
      final typeName = typeData['name'] as String?;
      if (targetTypeId == null || typeName == null) continue;

      final pokemonType = _parseTypeName(typeName);
      typeToIdMap[pokemonType] = targetTypeId;

      final efficacies = typeData['TypeefficaciesByTargetTypeId'] as List?;
      if (efficacies != null) {
        typeEfficacyByDefendingType[targetTypeId] =
            efficacies.cast<Map<String, dynamic>>();
      }
    }

    for (final attackingType in PokemonTypes.values) {
      if (attackingType == PokemonTypes.unknown ||
          attackingType == PokemonTypes.monster ||
          attackingType == PokemonTypes.shadow) {
        continue;
      }

      double totalMultiplier = 1.0;

      for (final defendingType in pokemonTypes) {
        if (defendingType == PokemonTypes.unknown ||
            defendingType == PokemonTypes.monster ||
            defendingType == PokemonTypes.shadow) {
          continue;
        }

        final defendingTypeId = typeToIdMap[defendingType];
        if (defendingTypeId == null) continue;

        final efficacies = typeEfficacyByDefendingType[defendingTypeId];

        if (efficacies != null) {
          double multiplier = 1.0;

          for (final efficacy in efficacies) {
            final attackingTypeData = efficacy['type'] as Map<String, dynamic>?;
            if (attackingTypeData == null) continue;

            final attackingTypeName = attackingTypeData['name'] as String?;
            if (attackingTypeName == null) continue;

            final matchingType = _parseTypeName(attackingTypeName);
            if (matchingType == attackingType) {
              final damageFactor = efficacy['damage_factor'] as int?;
              if (damageFactor != null) {
                multiplier = damageFactor / AppConstants.damageFactorDivisor;
                break;
              }
            }
          }

          totalMultiplier *= multiplier;
        }
      }

      effectivenessMap[attackingType] = totalMultiplier;
    }

      return effectivenessMap.entries
          .map((entry) => TypeDefenseInfo(
                type: entry.key,
                damageMultiplier: entry.value,
              ))
          .toList();
    } catch (e) {
      return [];
    }
  }

  static List<TypeDefenseInfo> _parseTypeOffenses(
    Map<String, dynamic> json,
    List<PokemonTypes> pokemonTypes,
  ) {
    try {
      if (pokemonTypes.isEmpty) {
        return [];
      }

      final Map<PokemonTypes, double> effectivenessMap = {};

      final pokemonTypesData = json['pokemontypes'];

      if (pokemonTypesData == null) {
        return [];
      }

      if (pokemonTypesData is! List || pokemonTypesData.isEmpty) {
        return [];
      }

      for (final pokemonTypeData in pokemonTypesData) {
        final typeData = pokemonTypeData['type'] as Map<String, dynamic>?;
        if (typeData == null) continue;

        final efficacies = typeData['typeefficacies'] as List?;
        if (efficacies == null) continue;

        for (final efficacy in efficacies) {
          final targetTypeData = efficacy['TypeByTargetTypeId'] as Map<String, dynamic>?;
          if (targetTypeData == null) continue;

          final targetTypeName = targetTypeData['name'] as String?;
          if (targetTypeName == null) continue;

          final defendingType = _parseTypeName(targetTypeName);
          if (defendingType == PokemonTypes.unknown ||
              defendingType == PokemonTypes.monster ||
              defendingType == PokemonTypes.shadow) {
            continue;
          }

          final damageFactor = efficacy['damage_factor'] as int?;
          if (damageFactor == null) continue;

          final currentMultiplier = effectivenessMap[defendingType] ?? 1.0;
          effectivenessMap[defendingType] = currentMultiplier * (damageFactor / AppConstants.damageFactorDivisor);
        }
      }

      return effectivenessMap.entries
          .map((entry) => TypeDefenseInfo(
                type: entry.key,
                damageMultiplier: entry.value,
              ))
          .toList();
    } catch (e) {
      return [];
    }
  }

  static PokemonTypes _parseTypeName(String name) {
    switch (name.toLowerCase()) {
      case 'normal':
        return PokemonTypes.normal;
      case 'fighting':
        return PokemonTypes.fighting;
      case 'flying':
        return PokemonTypes.flying;
      case 'poison':
        return PokemonTypes.poison;
      case 'ground':
        return PokemonTypes.ground;
      case 'rock':
        return PokemonTypes.rock;
      case 'bug':
        return PokemonTypes.bug;
      case 'ghost':
        return PokemonTypes.ghost;
      case 'steel':
        return PokemonTypes.steel;
      case 'fire':
        return PokemonTypes.fire;
      case 'water':
        return PokemonTypes.water;
      case 'grass':
        return PokemonTypes.grass;
      case 'electric':
        return PokemonTypes.electric;
      case 'psychic':
        return PokemonTypes.psychic;
      case 'ice':
        return PokemonTypes.ice;
      case 'dragon':
        return PokemonTypes.dragon;
      case 'dark':
        return PokemonTypes.dark;
      case 'fairy':
        return PokemonTypes.fairy;
      default:
        return PokemonTypes.unknown;
    }
  }
}
