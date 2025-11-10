import 'package:equatable/equatable.dart';
import 'package:pokedex/features/pokemon/domain/entities/pokemon_move.dart';
import 'package:pokedex/features/pokemon/domain/entities/pokemon_stat.dart';
import 'pokemon_ability.dart';
import 'pokemon_types.dart';

class Pokemon extends Equatable {
  final int id;
  final String name;
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
  
  const Pokemon({
    required this.id,
    required this.name,
    required this.types,
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
  
  String get imageUrl => 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
  
  String get displayName => name[0].toUpperCase() + name.substring(1);
  
  @override
  List<Object?> get props => [id, name, height, weight, baseExperience, types, abilities, stats, moves, genus, flavorText, genderRate, captureRate, baseHappiness, hatchCounter, growthRateName, eggGroups];
}
