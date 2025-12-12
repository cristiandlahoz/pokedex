import '../../../../core/di/injection_container.dart';
import '../../domain/entities/pokemon_ability.dart';
import '../../domain/entities/pokemon_details.dart';
import '../../domain/entities/pokemon_move.dart';
import '../../domain/entities/pokemon_stat.dart';
import '../../domain/entities/type_defense_info.dart';
import '../../domain/services/type_effectiveness_calculator.dart';
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

      final calculator = getIt<TypeEffectivenessCalculator>();
      final typeDefenses = calculator.calculateDefensiveEffectiveness(
        pokemonTypes: baseDto.types,
        pokemonTypesData: json,
      );
      final typeOffenses = calculator.calculateOffensiveEffectiveness(
        pokemonTypes: baseDto.types,
        pokemonTypesData: json,
      );

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
}
