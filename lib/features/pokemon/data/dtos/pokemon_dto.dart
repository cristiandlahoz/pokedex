import '../../domain/entities/pokemon.dart';
import '../../domain/entities/pokemon_types.dart';

class PokemonDto {
  final int id;
  final String name;
  final String? imageUrl;
  final int? height;
  final int? weight;
  final List<PokemonTypes> types;

  const PokemonDto({
    required this.id,
    required this.name,
    required this.types,
    this.imageUrl,
    this.height,
    this.weight,
  });

  Pokemon toDomain() {
    return Pokemon(
      id: id,
      name: name,
      types: types,
      imageUrl: imageUrl,
      height: height,
      weight: weight,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'pokemonsprites': imageUrl != null
          ? [
              {
                'sprites': {'front_default': imageUrl}
              }
            ]
          : null,
      'height': height,
      'weight': weight,
      'pokemontypes': types
          .map((type) => {
                'type': {'name': type.name}
              })
          .toList(),
    };
  }

  factory PokemonDto.fromJson(Map<String, dynamic> json) {
    final sprites =
        json['pokemonsprites']?[0]?['sprites'] as Map<String, dynamic>?;
    final imageUrl = sprites != null ? getSprite(sprites) : null;

    final List<PokemonTypes> types = [];
    if (json['pokemontypes'] != null) {
      for (final typeData in json['pokemontypes'] as List) {
        if (typeData['type'] != null && typeData['type']['name'] != null) {
          final typeName = typeData['type']['name'] as String;
          types.add(
            PokemonTypeExtension.fromString(typeName),
          );
        }
      }
    }

    return PokemonDto(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: imageUrl,
      height: json['height'] as int?,
      weight: json['weight'] as int?,
      types: types,
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
