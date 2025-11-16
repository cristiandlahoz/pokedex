import '../../../domain/entities/pokemon_move.dart';

class MovesParser {
  static List<PokemonMove> parse(dynamic movesData) {
    if (movesData == null || movesData is! List) return [];

    final moves = <PokemonMove>[];

    for (final moveData in movesData) {
      if (moveData is! Map) continue;
      if (moveData['move'] == null) continue;
      if (moveData['move']['name'] == null) continue;

      final move = moveData['move'];
      final typeData = move['type'];

      moves.add(PokemonMove(
        name: move['name'] as String,
        type: typeData != null && typeData['name'] != null
            ? typeData['name'] as String
            : null,
        power: move['power'] as int?,
        accuracy: move['accuracy'] as int?,
        pp: move['pp'] as int?,
      ));
    }

    return moves;
  }
}
