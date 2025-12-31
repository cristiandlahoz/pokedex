import 'package:injectable/injectable.dart';
import '../../../../core/exceptions/failures.dart' as failures;
import '../../../../core/logging/logger.dart';
import '../../../../core/logging/log_event.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/entities/pokemon_details.dart';
import '../../domain/entities/pokemon_move.dart';
import '../../domain/repositories/pokemon_repository.dart';
import '../../domain/value_objects/filters.dart';
import '../../domain/value_objects/sorting.dart';
import '../datasources/pokemon_graphql_datasource.dart';
import '../dtos/details_dto.dart';
import '../dtos/parsers/moves_parser.dart';

@LazySingleton(as: PokemonRepository)
class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonGraphQLDataSource dataSource;
  final Logger logger;

  PokemonRepositoryImpl(this.dataSource, this.logger);

  static int _counter = 0;

  @override
  int get movesPageSize => DesignTokens.defaultMovesLimit;

  @override
  Future<Result<List<Pokemon>>> getPokemonList({
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
  Future<Result<PokemonDetails>> getPokemonDetails(
    int id, {
    int movesPage = 0,
  }) async {
    return _handleRepositoryCall(
      operation: 'getPokemonDetails',
      call: () async {
        final result = await dataSource.getPokemonDetails(
          id,
          movesLimit: movesPageSize,
          movesOffset: movesPage * movesPageSize,
        );
        if (result == null) {
          throw const failures.ServerFailure('Pokemon not found');
        }
        return DetailsDto.fromJson(result).toDomainDetails();
      },
    );
  }

  @override
  Future<Result<List<PokemonMove>>> getPokemonMovesPage(
    int id, {
    required int page,
  }) async {
    return _handleRepositoryCall(
      operation: 'getPokemonMovesPage',
      call: () async {
        final result = await dataSource.getPokemonMoves(
          id,
          limit: movesPageSize,
          offset: page * movesPageSize,
        );
        return MovesParser.parse(result);
      },
    );
  }

  @override
  Future<Result<List<Pokemon>>> searchPokemon(String query) async {
    return _handleRepositoryCall(
      operation: 'searchPokemon',
      call: () async {
        final result = await dataSource.searchPokemon(query);
        return result.map((dto) => dto.toDomain()).toList();
      },
    );
  }

  /// Centralized error handling wrapper for repository calls
  Future<Result<T>> _handleRepositoryCall<T>({
    required String operation,
    required Future<T> Function() call,
  }) async {
    final requestId = _generateRequestId();
    final stopwatch = Stopwatch()..start();

    logger.logRequest(RequestEvent(id: requestId, operation: operation));

    try {
      final result = await call();

      logger.logResponse(
        ResponseEvent(
          requestId: requestId,
          durationMs: stopwatch.elapsedMilliseconds,
          status: 'success',
          itemCount: result is List ? result.length : null,
        ),
      );

      return Success(result);
    } on failures.Failure catch (failure) {
      logger.logError(
        ErrorEvent(
          requestId: requestId,
          errorType: failure.runtimeType.toString(),
          message: failure.message,
        ),
      );
      return ResultFailure(failure);
    }
  }

  String _generateRequestId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${_counter++}';
  }
}
