import '../../domain/entities/pokemon_types.dart';

extension TypeStringListExtension on List<String> {
  List<PokemonTypes> toPokemonTypes() {
    return map((type) => PokemonTypeExtension.fromString(type)).toList();
  }
}
