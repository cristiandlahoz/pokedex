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
  final List<TypeDefenseInfo> typeOffenses;

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

  factory PokemonDetailsDto.fromJson(Map<String, dynamic> json) {
    try {
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
      final abilitiesData = json['pokemonabilities'];
      if (abilitiesData != null && abilitiesData is List) {
        for (final abilityData in abilitiesData) {
          if (abilityData is Map && 
              abilityData['ability'] != null &&
              abilityData['ability']['name'] != null) {
            String? effect;
            final flavorTexts = abilityData['ability']['abilityflavortexts'] as List?;
            if (flavorTexts != null && flavorTexts.isNotEmpty) {
              effect = (flavorTexts[0]['flavor_text'] as String?)
                  ?.replaceAll('\n', ' ')
                  .replaceAll('\f', ' ');
            }
            
            abilities.add(
              PokemonAbility(
                id: abilityData['ability']['id'] as int,
                name: abilityData['ability']['name'] as String,
                isHidden: abilityData['is_hidden'] as bool? ?? false,
                effect: effect,
              ),
            );
          }
        }
      }

      final stats = <PokemonStat>[];
      final statsData = json['pokemonstats'];
      if (statsData != null && statsData is List) {
        for (final statData in statsData) {
          if (statData is Map && 
              statData['stat'] != null && 
              statData['stat']['name'] != null &&
              statData['base_stat'] != null) {
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
      final movesData = json['pokemonmoves'];
      if (movesData != null && movesData is List) {
        for (final moveData in movesData) {
          if (moveData is Map && 
              moveData['move'] != null && 
              moveData['move']['name'] != null) {
            final move = moveData['move'];
            final typeData = move['type'];
            
            moves.add(
              PokemonMove(
                name: move['name'] as String,
                type: typeData != null && typeData['name'] != null
                    ? typeData['name'] as String
                    : null,
                power: move['power'] as int?,
                accuracy: move['accuracy'] as int?,
                pp: move['pp'] as int?,
              ),
            );
          }
        }
      }

      final List<String> eggGroups = [];
      if (species != null) {
        final eggGroupsData = species['pokemonegggroups'];
        if (eggGroupsData != null && eggGroupsData is List) {
          for (final eggGroupData in eggGroupsData) {
            if (eggGroupData is Map &&
                eggGroupData['egggroup'] != null &&
                eggGroupData['egggroup']['name'] != null) {
              eggGroups.add(eggGroupData['egggroup']['name'] as String);
            }
          }
        }
      }

      final typeDefenses = _parseTypeDefenses(json, baseDto.types);
      final typeOffenses = _parseTypeOffenses(json, baseDto.types);

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
                multiplier = damageFactor / 100.0;
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
          effectivenessMap[defendingType] = currentMultiplier * (damageFactor / 100.0);
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
