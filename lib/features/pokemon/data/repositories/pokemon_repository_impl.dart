import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/repositories/pokemon_repository.dart';
import '../datasources/pokemon_graphql_datasource.dart';

@LazySingleton(as: PokemonRepository)
class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonGraphQLDataSource dataSource;
  
  PokemonRepositoryImpl(this.dataSource);
  
  @override
  Future<Either<Failure, List<Pokemon>>> getPokemonList({int page = 0, int limit = 20}) async {
    try {
      final result = await dataSource.getPokemonList(page: page, limit: limit);
      return Right(result);
    } on GraphQLException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error: ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<Failure, Pokemon>> getPokemonDetails(int id) async {
    try {
      final result = await dataSource.getPokemonDetails(id);
      if (result == null) {
        return const Left(ServerFailure('Pokemon not found'));
      }
      return Right(result);
    } on GraphQLException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error: ${e.toString()}'));
    }
  }
  
  @override
  Future<Either<Failure, List<Pokemon>>> searchPokemon(String query) async {
    try {
      final result = await dataSource.searchPokemon(query);
      return Right(result);
    } on GraphQLException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Unexpected error: ${e.toString()}'));
    }
  }
}
