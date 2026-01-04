import 'package:hive/hive.dart';

import '../../domain/entities/pokemon_ability.dart';

part 'pokemon_ability_hive_model.g.dart';

@HiveType(typeId: 2)
class PokemonAbilityHiveModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final bool isHidden;

  @HiveField(3)
  final String? effect;

  PokemonAbilityHiveModel({
    required this.id,
    required this.name,
    required this.isHidden,
    this.effect,
  });

  factory PokemonAbilityHiveModel.fromDomain(PokemonAbility ability) {
    return PokemonAbilityHiveModel(
      id: ability.id,
      name: ability.name,
      isHidden: ability.isHidden,
      effect: ability.effect,
    );
  }

  PokemonAbility toDomain() {
    return PokemonAbility(
      id: id,
      name: name,
      isHidden: isHidden,
      effect: effect,
    );
  }
}
