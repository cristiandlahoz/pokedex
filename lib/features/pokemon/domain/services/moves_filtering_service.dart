import 'package:injectable/injectable.dart';

import '../value_objects/game_version.dart';
import '../entities/pokemon_move.dart';
import '../value_objects/learn_method.dart';

@injectable
class MovesFilteringService {
  List<PokemonMove> filterByVersion(
    List<PokemonMove> moves,
    GameVersion? version,
  ) {
    if (version == null) return moves;
    final normalizedSelected = _normalizeVersionName(version.name);
    return moves
        .where((move) =>
            _normalizeVersionName(move.versionGroup) == normalizedSelected)
        .toList();
  }

  List<PokemonMove> filterByLearnMethod(
    List<PokemonMove> moves,
    String? method,
  ) {
    if (method == null) return moves;
    return moves.where((move) => move.learnMethod == method).toList();
  }

  List<PokemonMove> applyFilters(
    List<PokemonMove> moves, {
    GameVersion? version,
    String? learnMethod,
  }) {
    var filtered = moves;
    if (version != null) {
      filtered = filterByVersion(filtered, version);
    }
    if (learnMethod != null) {
      filtered = filterByLearnMethod(filtered, learnMethod);
    }
    return filtered;
  }

  List<String> getAvailableLearnMethods(List<PokemonMove> moves) {
    final methods = moves
        .where((move) => move.learnMethod != null)
        .map((move) => move.learnMethod!)
        .toSet()
        .toList();

    return _sortByPriority(methods);
  }

  String _normalizeVersionName(String? name) {
    if (name == null) return '';
    return name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
  }

  List<String> _sortByPriority(List<String> methods) {
    final priorityMap = {
      for (var method in LearnMethod.values) method.id: method.priority
    };

    methods.sort((a, b) {
      final priorityA = priorityMap[a] ?? 999;
      final priorityB = priorityMap[b] ?? 999;
      return priorityA.compareTo(priorityB);
    });

    return methods;
  }
}
