import '../../../domain/entities/pokemon_generation.dart';
import '../../../domain/value_objects/sorting.dart';
import '../../../domain/value_objects/filters.dart';

class PokemonQueryBuilder {
  Map<String, String> buildOrderBy(Sorting? sort) {
    if (sort == null) {
      return {'id': 'asc'};
    }

    final fieldMapping = {
      SortField.id: 'id',
      SortField.name: 'name',
      SortField.height: 'height',
      SortField.weight: 'weight',
      SortField.baseExperience: 'base_experience',
    };

    final directionMapping = {
      SortDirection.ascending: 'asc',
      SortDirection.descending: 'desc',
    };

    return {
      fieldMapping[sort.field]!: directionMapping[sort.direction]!,
    };
  }

  Map<String, dynamic>? buildWhereClause(Filters? filter) {
    if (filter == null || filter.isEmpty) {
      return null;
    }

    final List<Map<String, dynamic>> conditions = [];

    if (filter.types.isNotEmpty) {
      final typeNames = filter.types.map((t) => t.name).toList();
      conditions.add({
        'pokemontypes': {
          'type': {
            'name': {'_in': typeNames}
          }
        }
      });
    }

    if (filter.generations.isNotEmpty) {
      final generationIds = filter.generations.map((g) => g.id).toList();
      conditions.add({
        'pokemonspecy': {
          'generation_id': {'_in': generationIds}
        }
      });
    }

    if (conditions.isEmpty) return null;
    if (conditions.length == 1) return conditions.first;

    return {'_and': conditions};
  }
}
