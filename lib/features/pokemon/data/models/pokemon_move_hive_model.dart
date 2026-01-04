import 'package:hive/hive.dart';

import '../../domain/entities/pokemon_move.dart';

part 'pokemon_move_hive_model.g.dart';

@HiveType(typeId: 4)
class PokemonMoveHiveModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String? type;

  @HiveField(2)
  final int? power;

  @HiveField(3)
  final int? accuracy;

  @HiveField(4)
  final int? pp;

  PokemonMoveHiveModel({
    required this.name,
    this.type,
    this.power,
    this.accuracy,
    this.pp,
  });

  factory PokemonMoveHiveModel.fromDomain(PokemonMove move) {
    return PokemonMoveHiveModel(
      name: move.name,
      type: move.type,
      power: move.power,
      accuracy: move.accuracy,
      pp: move.pp,
    );
  }

  PokemonMove toDomain() {
    return PokemonMove(
      name: name,
      type: type,
      power: power,
      accuracy: accuracy,
      pp: pp,
    );
  }
}
