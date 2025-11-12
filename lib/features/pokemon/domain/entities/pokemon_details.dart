import 'pokemon.dart';
import 'pokemon_ability.dart';
import 'pokemon_move.dart';
import 'pokemon_stat.dart';
import 'type_defense_info.dart';

class PokemonDetails extends Pokemon {
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

  const PokemonDetails({
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

  @override
  List<Object?> get props => [
        ...super.props,
        genus,
        description,
        abilities,
        stats,
        moves,
        baseExperience,
        captureRate,
        baseHappiness,
        growthRate,
        eggGroup,
        genderRatio,
        eggGroups,
        typeDefenses,
        typeOffenses,
      ];
}
