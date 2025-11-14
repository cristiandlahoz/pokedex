import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/graphql/graphql_service.dart';
import '../../../../core/theme/tokens.dart';
import '../../domain/value_objects/filters.dart';
import '../../domain/value_objects/sorting.dart';
import 'pokemon_queries.dart';
import '../dtos/list_item_dto.dart';
import 'query_builders/pokemon_query_builder.dart';

@lazySingleton
class PokemonGraphQLDataSource {
  final GraphQLService graphQLService;
  final PokemonQueryBuilder _queryBuilder = PokemonQueryBuilder();

  PokemonGraphQLDataSource(this.graphQLService);

  Future<List<ListItemDto>> getPokemonList({
    int page = 0,
    int limit = DesignTokens.defaultPageSize,
    Sorting? sort,
    Filters? filter,
  }) async {
    final orderBy = _queryBuilder.buildOrderBy(sort);
    final whereClause = _queryBuilder.buildWhereClause(filter);

    final variables = {
      'limit': limit,
      'offset': page * limit,
      'order_by': [orderBy],
    };

    if (whereClause != null) {
      variables['where'] = whereClause;
    }

    final result = await graphQLService.query(
      QueryOptions(
        document: gql(getPokemonListQuery),
        variables: variables,
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );

    if (result.hasException) {
      throw GraphQLException.fromResult(result);
    }

    final List<dynamic> pokemonList = result.data!['pokemon'] as List<dynamic>;
    return pokemonList
        .map((json) => ListItemDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>?> getPokemonDetails(int id) async {
    try {
      QueryResult result;
      try {
        result = await graphQLService.query(
          QueryOptions(
            document: gql(getPokemonDetailsQuery),
            variables: {'id': id},
            fetchPolicy: FetchPolicy.cacheFirst,
          ),
        );
      } catch (e) {
        result = await graphQLService.query(
          QueryOptions(
            document: gql(getPokemonDetailsQuery),
            variables: {'id': id},
            fetchPolicy: FetchPolicy.cacheOnly,
          ),
        );
      }

      if (result.hasException) {
        throw GraphQLException.fromResult(result);
      }

      if (result.data == null) {
        return null;
      }

      final pokemonList = result.data!['pokemon'] as List<dynamic>?;
      if (pokemonList == null || pokemonList.isEmpty) return null;

      final originalData = pokemonList.first as Map<String, dynamic>;
      final pokemonData = Map<String, dynamic>.from(originalData);

      final pokemonTypesRaw = result.data!['pokemontype'] as List<dynamic>?;
      if (pokemonTypesRaw != null && pokemonTypesRaw.isNotEmpty) {
        final pokemonTypes = pokemonTypesRaw
            .map((pt) => Map<String, dynamic>.from(pt as Map<String, dynamic>))
            .toList();
        pokemonData['pokemontypes'] = pokemonTypes;
      }

      return pokemonData;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ListItemDto>> searchPokemon(String name) async {
    final result = await graphQLService.query(
      QueryOptions(
        document: gql(searchPokemonQuery),
        variables: {'name': '%$name%'},
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );

    if (result.hasException) {
      throw GraphQLException.fromResult(result);
    }

    final List<dynamic> pokemonList = result.data!['pokemon'] as List<dynamic>;
    return pokemonList
        .map((json) => ListItemDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
