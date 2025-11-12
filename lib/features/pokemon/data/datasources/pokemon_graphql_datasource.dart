import 'package:gql/language.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/graphql/graphql_service.dart';
import 'pokemon_queries.dart';
import '../dtos/pokemon_dto.dart';

@lazySingleton
class PokemonGraphQLDataSource {
  final GraphQLService graphQLService;
  
  PokemonGraphQLDataSource(this.graphQLService);
  
  Future<List<PokemonDto>> getPokemonList({int page = 0, int limit = 20}) async {
    final result = await graphQLService.query(
      QueryOptions(
        document: parseString(getPokemonListQuery),
        variables: {
          'limit': limit,
          'offset': page * limit,
        },
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );
    
    if (result.hasException) {
      throw GraphQLException.fromResult(result);
    }
    
    final List<dynamic> pokemonList = result.data!['pokemon'] as List<dynamic>;
    return pokemonList.map((json) => PokemonDto.fromJson(json as Map<String, dynamic>)).toList();
  }
  
  Future<Map<String, dynamic>?> getPokemonDetails(int id) async {
    final result = await graphQLService.query(
      QueryOptions(
        document: parseString(getPokemonDetailsQuery),
        variables: {'id': id},
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );
    
    if (result.hasException) {
      throw GraphQLException.fromResult(result);
    }
    
    final List<dynamic> pokemonList = result.data!['pokemon'] as List<dynamic>;
    if (pokemonList.isEmpty) return null;
    final pokemonData = pokemonList.first as Map<String, dynamic>;
    return pokemonData;
  }
  
  Future<List<PokemonDto>> searchPokemon(String name) async {
    final result = await graphQLService.query(
      QueryOptions(
        document: parseString(searchPokemonQuery),
        variables: {'name': '%$name%'},
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );
    
    if (result.hasException) {
      throw GraphQLException.fromResult(result);
    }
    
    final List<dynamic> pokemonList = result.data!['pokemon'] as List<dynamic>;
    return pokemonList.map((json) => PokemonDto.fromJson(json as Map<String, dynamic>)).toList();
  }
}
