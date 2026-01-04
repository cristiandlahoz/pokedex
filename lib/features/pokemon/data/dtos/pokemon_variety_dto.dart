import 'dart:convert';

import '../../domain/entities/pokemon_variety.dart';

class PokemonVarietyDTO {
  final int id;
  final String name;
  final bool isDefault;
  final int order;
  final List<dynamic>? types;
  final List<dynamic>? sprites;

  const PokemonVarietyDTO({
    required this.id,
    required this.name,
    required this.isDefault,
    required this.order,
    this.types,
    this.sprites,
  });

  factory PokemonVarietyDTO.fromJson(Map<String, dynamic> json) {
    return PokemonVarietyDTO(
      id: json['id'] as int,
      name: json['name'] as String,
      isDefault: json['is_default'] as bool? ?? false,
      order: json['order'] as int? ?? 0,
      types: json['pokemontypes'] as List<dynamic>?,
      sprites: json['pokemonsprites'] as List<dynamic>?,
    );
  }

  PokemonVariety toDomain() {
    final typeNames =
        types
            ?.map((t) => t['type']['name'] as String)
            .toList()
            .cast<String>() ??
        [];

    String? imageUrl;
    String? shinyImageUrl;

    if (sprites != null && sprites!.isNotEmpty) {
      try {
        final spritesData = sprites!.first['sprites'];
        final spritesMap = spritesData is String
            ? jsonDecode(spritesData) as Map<String, dynamic>
            : spritesData as Map<String, dynamic>;

        imageUrl = spritesMap['front_default'] as String?;
        shinyImageUrl = spritesMap['front_shiny'] as String?;
      } catch (e) {
        imageUrl = null;
        shinyImageUrl = null;
      }
    }

    return PokemonVariety(
      id: id,
      name: name,
      isDefault: isDefault,
      order: order,
      imageUrl: imageUrl,
      shinyImageUrl: shinyImageUrl,
      types: typeNames,
    );
  }
}
