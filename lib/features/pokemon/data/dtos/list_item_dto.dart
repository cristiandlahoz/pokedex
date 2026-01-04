import '../../domain/entities/pokemon.dart';
import '../../domain/entities/pokemon_types.dart';

class ListItemDto {
  final int id;
  final String name;
  final String? imageUrl;
  final String? shinyImageUrl;
  final int? height;
  final int? weight;
  final List<PokemonTypes> types;

  const ListItemDto({
    required this.id,
    required this.name,
    required this.types,
    this.imageUrl,
    this.shinyImageUrl,
    this.height,
    this.weight,
  });

  Pokemon toDomain() {
    return Pokemon(
      id: id,
      name: name,
      types: types,
      imageUrl: imageUrl,
      shinyImageUrl: shinyImageUrl,
      height: height,
      weight: weight,
    );
  }

  factory ListItemDto.fromJson(Map<String, dynamic> json) {
    final sprites =
        json['pokemonsprites']?[0]?['sprites'] as Map<String, dynamic>?;
    final imageUrl = sprites != null ? getSprite(sprites, false) : null;
    final shinyImageUrl = sprites != null ? getSprite(sprites, true) : null;

    final List<PokemonTypes> types = [];
    if (json['pokemontypes'] != null) {
      for (final typeData in json['pokemontypes'] as List) {
        if (typeData['type'] != null && typeData['type']['name'] != null) {
          final typeName = typeData['type']['name'] as String;
          types.add(PokemonTypeExtension.fromString(typeName));
        }
      }
    }

    return ListItemDto(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: imageUrl,
      shinyImageUrl: shinyImageUrl,
      height: json['height'] as int?,
      weight: json['weight'] as int?,
      types: types,
    );
  }

  static String? getSprite(Map<String, dynamic> sprites, bool shiny) {
    if (shiny) {
      final String? officialArtWorkShiny =
          sprites['other']?['official-artwork']?['front_shiny'] as String?;
      final String? homeShiny = sprites['other']?['home']?['front_shiny'] as String?;
      final String? defaultSpriteShiny = sprites['front_shiny'] as String?;

      return officialArtWorkShiny ?? homeShiny ?? defaultSpriteShiny;
    } else {
      final String? officialArtWork =
          sprites['other']?['official-artwork']?['front_default'] as String?;
      final String? home = sprites['other']?['home']?['front_default'] as String?;
      final String? defaultSprite = sprites['front_default'] as String?;

      return officialArtWork ?? home ?? defaultSprite;
    }
  }
}
