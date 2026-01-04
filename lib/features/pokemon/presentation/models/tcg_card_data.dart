import '../../domain/entities/pokemon_details.dart';
import '../../domain/entities/pokemon_move.dart';
import '../../domain/entities/type_defense_info.dart';
import '../../domain/entities/pokemon_types.dart';

enum TCGCardVariant {
  basic,
  alternate,
  shiny,
  reverseHolo,
  firstEdition,
  promo,
}

class TCGCardData {
  final PokemonDetails pokemon;
  final TCGCardVariant variant;

  TCGCardData(this.pokemon, {this.variant = TCGCardVariant.basic});

  String get name => pokemon.displayName;

  int get hp {
    final hpStat = pokemon.stats.firstWhere(
      (s) => s.name == 'hp',
      orElse: () => throw Exception('HP stat not found'),
    );
    return hpStat.baseStat;
  }

  PokemonTypes get primaryType => pokemon.types.first;

  String get pokedexNumber {
    return 'NO. ${pokemon.id.toString().padLeft(4, '0')}';
  }

  String get genus => pokemon.genus ?? 'Unknown Species';

  String get heightFormatted {
    if (pokemon.height == null) return 'Unknown';
    final heightInMeters = pokemon.height! / 10;
    final feet = (heightInMeters * 3.28084).floor();
    final inches = ((heightInMeters * 3.28084 - feet) * 12).round();
    return 'HT: $feet\'$inches"';
  }

  String get weightFormatted {
    if (pokemon.weight == null) return 'Unknown';
    final weightInKg = pokemon.weight! / 10;
    final pounds = (weightInKg * 2.20462).round();
    return 'WT: $pounds lbs.';
  }

  PokemonMove? get bestMove {
    final validMoves = pokemon.moves
        .where((m) => m.power != null && m.power! > 0)
        .toList();

    if (validMoves.isEmpty) return null;

    validMoves.sort((a, b) => b.power!.compareTo(a.power!));

    switch (variant) {
      case TCGCardVariant.basic:
      case TCGCardVariant.shiny:
      case TCGCardVariant.promo:
        return validMoves.first;
      case TCGCardVariant.alternate:
        return validMoves.length > 1 ? validMoves[1] : validMoves.first;
      case TCGCardVariant.reverseHolo:
        final mid = validMoves.length ~/ 2;
        return validMoves[mid];
      case TCGCardVariant.firstEdition:
        return validMoves.length > 2 ? validMoves[2] : validMoves.first;
    }
  }

  String? get abilityName {
    if (pokemon.abilities.isEmpty) return null;

    final abilityIndex = switch (variant) {
      TCGCardVariant.basic => 0,
      TCGCardVariant.alternate => pokemon.abilities.length > 1 ? 1 : 0,
      TCGCardVariant.shiny => 0,
      TCGCardVariant.reverseHolo => pokemon.abilities.length > 2 ? 2 : 0,
      TCGCardVariant.firstEdition => 0,
      TCGCardVariant.promo => pokemon.abilities.length > 1 ? 1 : 0,
    };

    return pokemon.abilities[abilityIndex].name;
  }

  String? get abilityEffect {
    if (pokemon.abilities.isEmpty) return null;

    final abilityIndex = switch (variant) {
      TCGCardVariant.basic => 0,
      TCGCardVariant.alternate => pokemon.abilities.length > 1 ? 1 : 0,
      TCGCardVariant.shiny => 0,
      TCGCardVariant.reverseHolo => pokemon.abilities.length > 2 ? 2 : 0,
      TCGCardVariant.firstEdition => 0,
      TCGCardVariant.promo => pokemon.abilities.length > 1 ? 1 : 0,
    };

    return pokemon.abilities[abilityIndex].effect;
  }

  List<TypeDefenseInfo> get weaknesses {
    return pokemon.typeDefenses
        .where((t) => t.damageMultiplier >= 2.0)
        .toList();
  }

  List<TypeDefenseInfo> get resistances {
    return pokemon.typeDefenses
        .where((t) => t.damageMultiplier > 0 && t.damageMultiplier <= 0.5)
        .toList();
  }

  int get retreatCost {
    final speedStat = pokemon.stats.firstWhere(
      (s) => s.name == 'speed',
      orElse: () => throw Exception('Speed stat not found'),
    );

    if (speedStat.baseStat >= 100) return 0;
    if (speedStat.baseStat >= 70) return 1;
    if (speedStat.baseStat >= 40) return 2;
    return 3;
  }

  String get imageUrl => pokemon.imageUrl ?? '';

  String get variantLabel {
    return switch (variant) {
      TCGCardVariant.basic => 'Basic',
      TCGCardVariant.alternate => 'Alt Art',
      TCGCardVariant.shiny => 'Shiny',
      TCGCardVariant.reverseHolo => 'Rev Holo',
      TCGCardVariant.firstEdition => '1st Ed',
      TCGCardVariant.promo => 'Promo',
    };
  }

  PokemonTypes get typeForCard {
    return switch (variant) {
      TCGCardVariant.basic => primaryType,
      TCGCardVariant.alternate =>
        pokemon.types.length > 1 ? pokemon.types[1] : primaryType,
      TCGCardVariant.shiny => primaryType,
      TCGCardVariant.reverseHolo => primaryType,
      TCGCardVariant.firstEdition => primaryType,
      TCGCardVariant.promo =>
        pokemon.types.length > 1 ? pokemon.types[1] : primaryType,
    };
  }
}
