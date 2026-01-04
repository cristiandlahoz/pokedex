import 'evolution_chain.dart';
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
  final EvolutionChain? evolutionChain;

  const PokemonDetails({
    required super.id,
    required super.name,
    required super.types,
    super.imageUrl,
    super.shinyImageUrl,
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
    this.evolutionChain,
  });

  PokemonDetails copyWith({
    int? id,
    String? name,
    List<String>? types,
    String? imageUrl,
    String? shinyImageUrl,
    double? height,
    double? weight,
    String? genus,
    String? description,
    List<PokemonAbility>? abilities,
    List<PokemonStat>? stats,
    List<PokemonMove>? moves,
    int? baseExperience,
    int? captureRate,
    int? baseHappiness,
    String? growthRate,
    String? eggGroup,
    int? genderRatio,
    List<String>? eggGroups,
    List<TypeDefenseInfo>? typeDefenses,
    List<TypeDefenseInfo>? typeOffenses,
    EvolutionChain? evolutionChain,
  }) {
    return PokemonDetails(
      id: id ?? this.id,
      name: name ?? this.name,
      types: types ?? this.types,
      imageUrl: imageUrl ?? this.imageUrl,
      shinyImageUrl: shinyImageUrl ?? this.shinyImageUrl,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      genus: genus ?? this.genus,
      description: description ?? this.description,
      abilities: abilities ?? this.abilities,
      stats: stats ?? this.stats,
      moves: moves ?? this.moves,
      baseExperience: baseExperience ?? this.baseExperience,
      captureRate: captureRate ?? this.captureRate,
      baseHappiness: baseHappiness ?? this.baseHappiness,
      growthRate: growthRate ?? this.growthRate,
      eggGroup: eggGroup ?? this.eggGroup,
      genderRatio: genderRatio ?? this.genderRatio,
      eggGroups: eggGroups ?? this.eggGroups,
      typeDefenses: typeDefenses ?? this.typeDefenses,
      typeOffenses: typeOffenses ?? this.typeOffenses,
      evolutionChain: evolutionChain ?? this.evolutionChain,
    );
  }

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
    evolutionChain,
  ];
}
