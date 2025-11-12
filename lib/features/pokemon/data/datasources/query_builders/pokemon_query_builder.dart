import '../../../domain/entities/pokemon_generation.dart';
import '../../../domain/value_objects/sort_criteria.dart';
import '../../../domain/value_objects/filter_criteria.dart';

class PokemonQueryBuilder {
  Map<String, String> buildOrderBy(SortCriteria? criteria) {
    if (criteria == null) {
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
      fieldMapping[criteria.field]!: directionMapping[criteria.direction]!,
    };
  }

  Map<String, dynamic>? buildWhereClause(FilterCriteria? criteria) {
    if (criteria == null || criteria.isEmpty) {
      return null;
    }

    final List<Map<String, dynamic>> conditions = [];

    if (criteria.types.isNotEmpty) {
      final typeNames = criteria.types.map((t) => t.name).toList();
      conditions.add({
        'pokemontypes': {
          'type': {
            'name': {'_in': typeNames}
          }
        }
      });
    }

    if (criteria.generations.isNotEmpty) {
      final generationIds = criteria.generations.map((g) => g.id).toList();
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
