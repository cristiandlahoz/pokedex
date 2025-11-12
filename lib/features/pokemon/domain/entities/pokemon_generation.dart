enum PokemonGeneration {
  gen1,
  gen2,
  gen3,
  gen4,
  gen5,
  gen6,
  gen7,
  gen8,
  gen9,
}

extension PokemonGenerationExtension on PokemonGeneration {
  int get id {
    switch (this) {
      case PokemonGeneration.gen1:
        return 1;
      case PokemonGeneration.gen2:
        return 2;
      case PokemonGeneration.gen3:
        return 3;
      case PokemonGeneration.gen4:
        return 4;
      case PokemonGeneration.gen5:
        return 5;
      case PokemonGeneration.gen6:
        return 6;
      case PokemonGeneration.gen7:
        return 7;
      case PokemonGeneration.gen8:
        return 8;
      case PokemonGeneration.gen9:
        return 9;
    }
  }

  String get displayName {
    switch (this) {
      case PokemonGeneration.gen1:
        return 'Generation I';
      case PokemonGeneration.gen2:
        return 'Generation II';
      case PokemonGeneration.gen3:
        return 'Generation III';
      case PokemonGeneration.gen4:
        return 'Generation IV';
      case PokemonGeneration.gen5:
        return 'Generation V';
      case PokemonGeneration.gen6:
        return 'Generation VI';
      case PokemonGeneration.gen7:
        return 'Generation VII';
      case PokemonGeneration.gen8:
        return 'Generation VIII';
      case PokemonGeneration.gen9:
        return 'Generation IX';
    }
  }

  String get shortName {
    switch (this) {
      case PokemonGeneration.gen1:
        return 'Gen I';
      case PokemonGeneration.gen2:
        return 'Gen II';
      case PokemonGeneration.gen3:
        return 'Gen III';
      case PokemonGeneration.gen4:
        return 'Gen IV';
      case PokemonGeneration.gen5:
        return 'Gen V';
      case PokemonGeneration.gen6:
        return 'Gen VI';
      case PokemonGeneration.gen7:
        return 'Gen VII';
      case PokemonGeneration.gen8:
        return 'Gen VIII';
      case PokemonGeneration.gen9:
        return 'Gen IX';
    }
  }

  String get region {
    switch (this) {
      case PokemonGeneration.gen1:
        return 'Kanto';
      case PokemonGeneration.gen2:
        return 'Johto';
      case PokemonGeneration.gen3:
        return 'Hoenn';
      case PokemonGeneration.gen4:
        return 'Sinnoh';
      case PokemonGeneration.gen5:
        return 'Unova';
      case PokemonGeneration.gen6:
        return 'Kalos';
      case PokemonGeneration.gen7:
        return 'Alola';
      case PokemonGeneration.gen8:
        return 'Galar';
      case PokemonGeneration.gen9:
        return 'Paldea';
    }
  }

  String get range {
    switch (this) {
      case PokemonGeneration.gen1:
        return '#1 - #151';
      case PokemonGeneration.gen2:
        return '#152 - #251';
      case PokemonGeneration.gen3:
        return '#252 - #386';
      case PokemonGeneration.gen4:
        return '#387 - #493';
      case PokemonGeneration.gen5:
        return '#494 - #649';
      case PokemonGeneration.gen6:
        return '#650 - #721';
      case PokemonGeneration.gen7:
        return '#722 - #809';
      case PokemonGeneration.gen8:
        return '#810 - #905';
      case PokemonGeneration.gen9:
        return '#906+';
    }
  }
}
