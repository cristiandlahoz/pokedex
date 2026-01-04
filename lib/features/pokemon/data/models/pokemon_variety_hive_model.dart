import 'package:hive/hive.dart';

import '../../domain/entities/pokemon_variety.dart';

part 'pokemon_variety_hive_model.g.dart';

@HiveType(typeId: 11)
class PokemonVarietyHiveModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final bool isDefault;

  @HiveField(3)
  final int order;

  @HiveField(4)
  final String? imageUrl;

  @HiveField(5)
  final String? shinyImageUrl;

  @HiveField(6)
  final List<String> types;

  PokemonVarietyHiveModel({
    required this.id,
    required this.name,
    required this.isDefault,
    required this.order,
    this.imageUrl,
    this.shinyImageUrl,
    required this.types,
  });

  factory PokemonVarietyHiveModel.fromDomain(PokemonVariety variety) {
    return PokemonVarietyHiveModel(
      id: variety.id,
      name: variety.name,
      isDefault: variety.isDefault,
      order: variety.order,
      imageUrl: variety.imageUrl,
      shinyImageUrl: variety.shinyImageUrl,
      types: variety.types,
    );
  }

  PokemonVariety toDomain() {
    return PokemonVariety(
      id: id,
      name: name,
      isDefault: isDefault,
      order: order,
      imageUrl: imageUrl,
      shinyImageUrl: shinyImageUrl,
      types: types,
    );
  }
}
