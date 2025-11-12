import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/exceptions/failures.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/repositories/pokemon_repository.dart';
import '../datasources/pokemon_graphql_datasource.dart';

@LazySingleton(as: PokemonRepository)
class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonGraphQLDataSource dataSource;

  PokemonRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<Pokemon>>> getPokemonList({
    int page = 0,
    int limit = 20,
  }) async {
    try {
      final result = await dataSource.getPokemonList(page: page, limit: limit);
      return Right(result.map((dto) => dto.toDomain()).toList());
    } on GraphQLException catch (e, stackTrace) {
      _logError('getPokemonList', e, stackTrace);
      return Left(
        ServerFailure(e.message, stackTrace: stackTrace, originalError: e),
      );
    } on NetworkException catch (e, stackTrace) {
      _logError('getPokemonList', e, stackTrace);
      return Left(
        NetworkFailure(e.message, stackTrace: stackTrace, originalError: e),
      );
    } catch (e, stackTrace) {
      _logError('getPokemonList', e, stackTrace);
      return Left(
        UnexpectedFailure(
          'Unexpected error: ${e.toString()}',
          stackTrace: stackTrace,
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, Pokemon>> getPokemonDetails(int id) async {
    try {
      final result = await dataSource.getPokemonDetails(id);
      if (result == null) {
        return const Left(ServerFailure('Pokemon not found'));
      }
      return Right(result.toDomain());
    } on GraphQLException catch (e, stackTrace) {
      _logError('getPokemonDetails', e, stackTrace);
      return Left(
        ServerFailure(e.message, stackTrace: stackTrace, originalError: e),
      );
    } on NetworkException catch (e, stackTrace) {
      _logError('getPokemonDetails', e, stackTrace);
      return Left(
        NetworkFailure(e.message, stackTrace: stackTrace, originalError: e),
      );
    } catch (e, stackTrace) {
      _logError('getPokemonDetails', e, stackTrace);
      return Left(
        UnexpectedFailure(
          'Unexpected error: ${e.toString()}',
          stackTrace: stackTrace,
          originalError: e,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, List<Pokemon>>> searchPokemon(String query) async {
    const operation = 'searchPokemon';
    try {
      final result = await dataSource.searchPokemon(query);
      return Right(result.map((dto) => dto.toDomain()).toList());
    } on GraphQLException catch (e, stackTrace) {
      _logError(operation, e, stackTrace);
      return Left(
        ServerFailure(e.message, stackTrace: stackTrace, originalError: e),
      );
    } on NetworkException catch (e, stackTrace) {
      _logError(operation, e, stackTrace);
      return Left(
        NetworkFailure(e.message, stackTrace: stackTrace, originalError: e),
      );
    } catch (e, stackTrace) {
      _logError(operation, e, stackTrace);
      return Left(
        UnexpectedFailure(
          'Unexpected error: ${e.toString()}',
          stackTrace: stackTrace,
          originalError: e,
        ),
      );
    }
  }

  void _logError(String operation, Object error, StackTrace stackTrace) {
    if (kDebugMode) {
      debugPrint(
        'canonical-log-line error_repository_implementation Error in $operation:',
      );
      debugPrint('   Error: $error');
      debugPrint('   Stack trace:\n$stackTrace');
    }
  }
}
