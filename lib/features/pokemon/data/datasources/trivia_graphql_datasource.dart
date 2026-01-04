import 'dart:math';

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/exceptions/exceptions.dart' as core_exceptions;
import '../../../../core/graphql/graphql_service.dart';
import '../../domain/entities/pokemon.dart';
import '../../presentation/constants/trivia.dart';
import '../dtos/list_item_dto.dart';

@lazySingleton
class TriviaGraphQLDataSource {
  final GraphQLService graphQLService;
  final Random _random = Random();

  TriviaGraphQLDataSource(this.graphQLService);

  static const String _getPokemonByIdsQuery = """
    query GetPokemonByIds(\$ids: [Int!]!) {
      pokemon(where: {id: {_in: \$ids}}) {
        id
        name
        pokemontypes {
          type {
            id
            name
          }
        }
        pokemonsprites {
          sprites
        }
      }
    }
  """;

  List<int> _generateRandomIds(int count) {
    final ids = <int>{};
    while (ids.length < count) {
      final id =
          TriviaConstants.minPokemonId +
          _random.nextInt(
            TriviaConstants.maxPokemonId - TriviaConstants.minPokemonId + 1,
          );
      ids.add(id);
    }
    return ids.toList();
  }

  Future<List<Pokemon>> getPokemonByIds(List<int> ids) async {
    try {
      final result = await graphQLService.query(
        QueryOptions(
          document: gql(_getPokemonByIdsQuery),
          variables: {'ids': ids},
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        throw core_exceptions.GraphQLException.fromResult(result);
      }

      if (result.data == null) {
        throw const core_exceptions.ServerException(
          'No data returned from GraphQL query',
        );
      }

      final List<dynamic> pokemonList =
          result.data!['pokemon'] as List<dynamic>;

      if (pokemonList.isEmpty) {
        throw const core_exceptions.ServerException(
          'No Pokemon found for the given IDs',
        );
      }

      return pokemonList
          .map(
            (json) =>
                ListItemDto.fromJson(json as Map<String, dynamic>).toDomain(),
          )
          .toList();
    } catch (e) {
      if (e is core_exceptions.ServerException) rethrow;
      throw core_exceptions.ServerException('Failed to fetch Pokemon: $e');
    }
  }

  Future<List<Pokemon>> getRandomPokemon(int count) async {
    final ids = _generateRandomIds(count);
    return getPokemonByIds(ids);
  }
}
