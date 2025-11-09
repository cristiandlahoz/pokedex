import '../../domain/entities/pokemon.dart';
import '../../domain/entities/pokemon_ability.dart';
import '../../domain/entities/pokemon_move.dart';
import '../../domain/entities/pokemon_stat.dart';
import '../../domain/entities/pokemon_types.dart';

class PokemonDto extends Pokemon {
  const PokemonDto({
    required super.id,
    required super.name,
    required super.types,
    super.height,
    super.weight,
    super.baseExperience,
    super.abilities,
    super.stats,
    super.moves,
  });

  factory PokemonDto.fromJson(Map<String, dynamic> json) {
    final List<PokemonTypes> types = [];
    if (json['pokemontypes'] != null) {
      for (final typeData in json['pokemontypes'] as List) {
        if (typeData['type'] != null && typeData['type']['name'] != null) {
          types.add(PokemonTypeExtension.fromString(typeData['type']['name'] as String));
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
          abilities.add(PokemonAbility(
            id: abilityData['ability']['id'] as int,
            name: abilityData['ability']['name'] as String,
            isHidden: abilityData['is_hidden'] as bool? ?? false,
          ));
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
          stats.add(PokemonStat(
            name: statData['stat']['name'] as String,
            baseStat: statData['base_stat'] as int,
          ));
        }
      }
    }

    List<PokemonMove>? moves;
    if (json['pokemonmoves'] != null) {
      moves = [];
      for (final moveData in json['pokemonmoves'] as List) {
        if (moveData['move'] != null && moveData['move']['name'] != null) {
          moves.add(PokemonMove(
            name: moveData['move']['name'] as String,
          ));
        }
      }
    }

    return PokemonDto(
      id: json['id'] as int,
      name: json['name'] as String,
      height: json['height'] as int?,
      weight: json['weight'] as int?,
      baseExperience: json['base_experience'] as int?,
      types: types,
      abilities: abilities,
      stats: stats,
      moves: moves,
    );
  }
}
