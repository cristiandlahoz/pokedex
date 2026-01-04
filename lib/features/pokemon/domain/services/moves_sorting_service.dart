import 'package:injectable/injectable.dart';

import '../entities/pokemon_move.dart';

enum MoveSortColumn { name, level, power, accuracy, pp }

@injectable
class MovesSortingService {
  List<PokemonMove> sort(
    List<PokemonMove> moves,
    MoveSortColumn column,
    bool ascending,
  ) {
    final sorted = List<PokemonMove>.from(moves);
    sorted.sort(_getComparator(column, ascending));
    return sorted;
  }

  Comparator<PokemonMove> _getComparator(
    MoveSortColumn column,
    bool ascending,
  ) {
    return switch (column) {
      MoveSortColumn.name => (a, b) => _compareStrings(
        a.name,
        b.name,
        ascending,
      ),
      MoveSortColumn.level => (a, b) => _compareNullableInts(
        a.level,
        b.level,
        ascending,
      ),
      MoveSortColumn.power => (a, b) => _compareNullableInts(
        a.power,
        b.power,
        ascending,
      ),
      MoveSortColumn.accuracy => (a, b) => _compareNullableInts(
        a.accuracy,
        b.accuracy,
        ascending,
      ),
      MoveSortColumn.pp => (a, b) => _compareNullableInts(
        a.pp,
        b.pp,
        ascending,
      ),
    };
  }

  int _compareNullableInts(int? a, int? b, bool ascending) {
    if (a == null && b == null) return 0;
    if (a == null) return 1;
    if (b == null) return -1;
    return ascending ? a.compareTo(b) : b.compareTo(a);
  }

  int _compareStrings(String a, String b, bool ascending) {
    return ascending ? a.compareTo(b) : b.compareTo(a);
  }
}
