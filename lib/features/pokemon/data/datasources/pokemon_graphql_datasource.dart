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
    try {
      QueryResult result;
      try {
        result = await graphQLService.query(
          QueryOptions(
            document: parseString(getPokemonDetailsQuery),
            variables: {'id': id},
            fetchPolicy: FetchPolicy.cacheFirst,
          ),
        );
      } catch (e) {
        result = await graphQLService.query(
          QueryOptions(
            document: parseString(getPokemonDetailsQuery),
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
        final pokemonTypes = pokemonTypesRaw.map((pt) => Map<String, dynamic>.from(pt as Map<String, dynamic>)).toList();
        
        final typeIds = pokemonTypes
            .map((pt) => pt['type']?['id'] as int?)
            .where((id) => id != null)
            .cast<int>()
            .toList();
        
        if (typeIds.isNotEmpty) {
          QueryResult efficacyResult;
          try {
            efficacyResult = await graphQLService.query(
              QueryOptions(
                document: parseString(getTypeEfficaciesQuery),
                variables: {'typeIds': typeIds},
                fetchPolicy: FetchPolicy.cacheFirst,
              ),
            );
          } catch (e) {
            efficacyResult = await graphQLService.query(
              QueryOptions(
                document: parseString(getTypeEfficaciesQuery),
                variables: {'typeIds': typeIds},
                fetchPolicy: FetchPolicy.cacheOnly,
              ),
            );
          }
          
          if (!efficacyResult.hasException && efficacyResult.data != null) {
            final types = efficacyResult.data!['type'] as List<dynamic>?;
            if (types != null) {
              for (var i = 0; i < pokemonTypes.length; i++) {
                final typeData = pokemonTypes[i]['type'];
                if (typeData != null) {
                  final typeId = typeData['id'];
                  final matchingType = types.firstWhere(
                    (t) => t['id'] == typeId,
                    orElse: () => null,
                  );
                  if (matchingType != null) {
                    final typeDataMap = Map<String, dynamic>.from(typeData as Map<String, dynamic>);
                    typeDataMap['TypeefficaciesByTargetTypeId'] = matchingType['TypeefficaciesByTargetTypeId'];
                    pokemonTypes[i]['type'] = typeDataMap;
                  }
                }
              }
            }
          }
        }
        
        pokemonData['pokemontypes'] = pokemonTypes;
      }
      
      return pokemonData;
    } catch (e) {
      rethrow;
    }
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
