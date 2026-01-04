import 'package:hive/hive.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/entities/pokemon_types.dart';

part 'pokemon_hive_model.g.dart';

@HiveType(typeId: 0)
class PokemonHiveModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? imageUrl;

  @HiveField(3)
  final int? height;

  @HiveField(4)
  final int? weight;

  @HiveField(5)
  final List<int> typeIds;

  @HiveField(6)
  final DateTime addedAt;

  PokemonHiveModel({
    required this.id,
    required this.name,
    required this.typeIds,
    required this.addedAt,
    this.imageUrl,
    this.height,
    this.weight,
  });

  factory PokemonHiveModel.fromDomain(Pokemon pokemon) {
    return PokemonHiveModel(
      id: pokemon.id,
      name: pokemon.name,
      imageUrl: pokemon.imageUrl,
      height: pokemon.height,
      weight: pokemon.weight,
      typeIds: pokemon.types.map((t) => t.index).toList(),
      addedAt: DateTime.now(),
    );
  }

  Pokemon toDomain() {
    return Pokemon(
      id: id,
      name: name,
      imageUrl: imageUrl,
      height: height,
      weight: weight,
      types: typeIds.map((i) => PokemonTypes.values[i]).toList(),
    );
  }
}
