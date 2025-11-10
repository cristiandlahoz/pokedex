enum PokemonTypes {
  grass,
  poison,
  fire,
  flying,
  water,
  bug,
  normal,
  electric,
  ground,
  fairy,
  fighting,
  psychic,
  rock,
  steel,
  ice,
  ghost,
  dragon,
  dark,
  monster,
  unknown,
  shadow,
}

extension PokemonTypeExtension on PokemonTypes {
  static PokemonTypes fromString(String type) {
    switch (type.toLowerCase()) {
      case 'grass':
        return PokemonTypes.grass;
      case 'poison':
        return PokemonTypes.poison;
      case 'fire':
        return PokemonTypes.fire;
      case 'flying':
        return PokemonTypes.flying;
      case 'water':
        return PokemonTypes.water;
      case 'bug':
        return PokemonTypes.bug;
      case 'normal':
        return PokemonTypes.normal;
      case 'electric':
        return PokemonTypes.electric;
      case 'ground':
        return PokemonTypes.ground;
      case 'fairy':
        return PokemonTypes.fairy;
      case 'fighting':
        return PokemonTypes.fighting;
      case 'psychic':
        return PokemonTypes.psychic;
      case 'rock':
        return PokemonTypes.rock;
      case 'steel':
        return PokemonTypes.steel;
      case 'ice':
        return PokemonTypes.ice;
      case 'ghost':
        return PokemonTypes.ghost;
      case 'dragon':
        return PokemonTypes.dragon;
      case 'dark':
        return PokemonTypes.dark;
      case 'monster':
        return PokemonTypes.monster;
      case 'shadow':
        return PokemonTypes.shadow;
      default:
        return PokemonTypes.unknown;
    }
  }

  String get name {
    return toString().split('.').last;
  }

  String get displayName {
    final typeName = name;
    return typeName[0].toUpperCase() + typeName.substring(1);
  }
}
