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
      final versionGroupData = moveData['versiongroup'];
      final learnMethodData = moveData['movelearnmethod'];
      
      final machinesData = move['machines'];
      int? machineNumber;
      if (machinesData != null && machinesData is List && machinesData.isNotEmpty) {
        final firstMachine = machinesData[0];
        if (firstMachine is Map && firstMachine['machine_number'] != null) {
          machineNumber = firstMachine['machine_number'] as int?;
        }
      }

      moves.add(PokemonMove(
        name: move['name'] as String,
        type: typeData != null && typeData['name'] != null
            ? typeData['name'] as String
            : null,
        power: move['power'] as int?,
        accuracy: move['accuracy'] as int?,
        pp: move['pp'] as int?,
        level: moveData['level'] as int?,
        learnMethod: learnMethodData != null && learnMethodData['name'] != null
            ? learnMethodData['name'] as String
            : null,
        versionGroup: versionGroupData != null && versionGroupData['name'] != null
            ? versionGroupData['name'] as String
            : null,
        machineNumber: machineNumber,
      ));
    }

    return moves;
  }
}
