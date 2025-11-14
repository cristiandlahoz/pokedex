import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/exceptions/failures.dart';
import '../../../../core/theme/tokens.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/entities/pokemon_details.dart';
import '../../domain/repositories/pokemon_repository.dart';
import '../../domain/value_objects/filters.dart';
import '../../domain/value_objects/sorting.dart';
import '../datasources/pokemon_graphql_datasource.dart';
import '../dtos/details_dto.dart';

@LazySingleton(as: PokemonRepository)
class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonGraphQLDataSource dataSource;

  PokemonRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, List<Pokemon>>> getPokemonList({
    int page = 0,
    int limit = DesignTokens.defaultPageSize,
    Sorting? sort,
    Filters? filter,
  }) async {
    return _handleRepositoryCall(
      operation: 'getPokemonList',
      call: () async {
        final result = await dataSource.getPokemonList(
          page: page,
          limit: limit,
          sort: sort,
          filter: filter,
        );
        return result.map((dto) => dto.toDomain()).toList();
      },
    );
  }

  @override
  Future<Either<Failure, PokemonDetails>> getPokemonDetails(int id) async {
    return _handleRepositoryCall(
      operation: 'getPokemonDetails',
      call: () async {
        final result = await dataSource.getPokemonDetails(id);
        if (result == null) {
          throw const ServerFailure('Pokemon not found');
        }
        return DetailsDto.fromJson(result).toDomainDetails();
      },
    );
  }

  @override
  Future<Either<Failure, List<Pokemon>>> searchPokemon(String query) async {
    return _handleRepositoryCall(
      operation: 'searchPokemon',
      call: () async {
        final result = await dataSource.searchPokemon(query);
        return result.map((dto) => dto.toDomain()).toList();
      },
    );
  }

  /// Centralized error handling wrapper for repository calls
  /// Eliminates duplication and ensures consistent error handling
  Future<Either<Failure, T>> _handleRepositoryCall<T>({
    required String operation,
    required Future<T> Function() call,
  }) async {
    try {
      final result = await call();
      return Right(result);
    } on Failure catch (failure) {
      // If it's already a Failure (like from null check), just return it
      _logError(operation, failure, StackTrace.current);
      return Left(failure);
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
