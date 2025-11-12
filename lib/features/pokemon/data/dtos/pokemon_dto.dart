import '../../domain/entities/pokemon.dart';
import '../../domain/entities/pokemon_ability.dart';
import '../../domain/entities/pokemon_move.dart';
import '../../domain/entities/pokemon_stat.dart';
import '../../domain/entities/pokemon_types.dart';

class PokemonDto {
  final int id;
  final String name;
  final String? imageUrl;
  final int? height;
  final int? weight;
  final int? baseExperience;
  final List<PokemonTypes> types;
  final List<PokemonAbility>? abilities;
  final List<PokemonStat>? stats;
  final List<PokemonMove>? moves;
  final String? genus;
  final String? flavorText;
  final int? genderRate;
  final int? captureRate;
  final int? baseHappiness;
  final int? hatchCounter;
  final String? growthRateName;
  final List<String>? eggGroups;

  const PokemonDto({
    required this.id,
    required this.name,
    required this.types,
    this.imageUrl,
    this.height,
    this.weight,
    this.baseExperience,
    this.abilities,
    this.stats,
    this.moves,
    this.genus,
    this.flavorText,
    this.genderRate,
    this.captureRate,
    this.baseHappiness,
    this.hatchCounter,
    this.growthRateName,
    this.eggGroups,
  });

  Pokemon toDomain() {
    return Pokemon(
      id: id,
      name: name,
      types: types,
      imageUrl: imageUrl,
      height: height,
      weight: weight,
      baseExperience: baseExperience,
      abilities: abilities,
      stats: stats,
      moves: moves,
      genus: genus,
      flavorText: flavorText,
      genderRate: genderRate,
      captureRate: captureRate,
      baseHappiness: baseHappiness,
      hatchCounter: hatchCounter,
      growthRateName: growthRateName,
      eggGroups: eggGroups,
    );
  }

  factory PokemonDto.fromJson(Map<String, dynamic> json) {
    final sprites =
        json['pokemonsprites']?[0]?['sprites'] as Map<String, dynamic>?;
    final imageUrl = sprites != null ? getSprite(sprites) : null;

    final List<PokemonTypes> types = [];
    if (json['pokemontypes'] != null) {
      for (final typeData in json['pokemontypes'] as List) {
        if (typeData['type'] != null && typeData['type']['name'] != null) {
          types.add(
            PokemonTypeExtension.fromString(typeData['type']['name'] as String),
          );
        }
      }
    }

    List<PokemonAbility>? abilities;
    if (json['pokemonabilities'] != null) {
      abilities = [];
      for (final abilityData in json['pokemonabilities'] as List) {
        if (abilityData['ability'] != null &&
            abilityData['ability']['id'] != null &&
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

    List<PokemonStat>? stats;
    if (json['pokemonstats'] != null) {
      stats = [];
      for (final statData in json['pokemonstats'] as List) {
        if (statData['stat'] != null &&
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

    List<PokemonMove>? moves;
    if (json['pokemonmoves'] != null) {
      moves = [];
      for (final moveData in json['pokemonmoves'] as List) {
        if (moveData['move'] != null && moveData['move']['name'] != null) {
          moves.add(PokemonMove(name: moveData['move']['name'] as String));
        }
      }
    }

    String? genus;
    String? flavorText;
    int? genderRate;
    int? captureRate;
    int? baseHappiness;
    int? hatchCounter;
    String? growthRateName;
    List<String>? eggGroups;

    if (json['pokemonspecy'] != null) {
      final speciesData = json['pokemonspecy'] as Map<String, dynamic>;

      genderRate = speciesData['gender_rate'] as int?;
      captureRate = speciesData['capture_rate'] as int?;
      baseHappiness = speciesData['base_happiness'] as int?;
      hatchCounter = speciesData['hatch_counter'] as int?;

      if (speciesData['growthrate'] != null) {
        growthRateName = speciesData['growthrate']['name'] as String?;
      }

      if (speciesData['pokemonegggroups'] != null) {
        eggGroups = [];
        for (final eggGroupData in speciesData['pokemonegggroups'] as List) {
          if (eggGroupData['egggroup'] != null &&
              eggGroupData['egggroup']['name'] != null) {
            eggGroups.add(eggGroupData['egggroup']['name'] as String);
          }
        }
      }

      if (speciesData['pokemonspeciesnames'] != null &&
          (speciesData['pokemonspeciesnames'] as List).isNotEmpty) {
        final nameData = (speciesData['pokemonspeciesnames'] as List)[0];
        genus = nameData['genus'] as String?;
      }

      if (speciesData['pokemonspeciesflavortexts'] != null &&
          (speciesData['pokemonspeciesflavortexts'] as List).isNotEmpty) {
        final flavorData =
            (speciesData['pokemonspeciesflavortexts'] as List)[0];
        flavorText = flavorData['flavor_text'] as String?;
      }
    }

    return PokemonDto(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: imageUrl,
      height: json['height'] as int?,
      weight: json['weight'] as int?,
      baseExperience: json['base_experience'] as int?,
      types: types,
      abilities: abilities,
      stats: stats,
      moves: moves,
      genus: genus,
      flavorText: flavorText,
      genderRate: genderRate,
      captureRate: captureRate,
      baseHappiness: baseHappiness,
      hatchCounter: hatchCounter,
      growthRateName: growthRateName,
      eggGroups: eggGroups,
    );
  }

  static String? getSprite(Map<String, dynamic> sprites) {
    final String? officialArtWork =
        sprites['other']?['official-artwork']?['front_default'] as String?;
    final String? home = sprites['other']?['home']?['front_default'] as String?;
    final String? defaultSprite = sprites['front_default'] as String?;

    return officialArtWork ?? home ?? defaultSprite;
  }
}
