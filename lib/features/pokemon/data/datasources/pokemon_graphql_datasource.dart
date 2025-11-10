import 'package:gql/language.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/graphql/graphql_service.dart';
import '../../../../core/graphql/pokemon_queries.dart';
import '../models/pokemon_dto.dart';

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
  
  Future<PokemonDto?> getPokemonDetails(int id) async {
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
    return PokemonDto.fromJson(pokemonList.first as Map<String, dynamic>);
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
