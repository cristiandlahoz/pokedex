import '../../domain/entities/pokemon_types.dart';

class PokemonTypeIcons {
  static String getIconPath(PokemonTypes type) {
    return 'assets/icons/types/${type.name.toLowerCase()}.svg';
  }
}
