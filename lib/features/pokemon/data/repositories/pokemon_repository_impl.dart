import 'package:injectable/injectable.dart';
import 'package:pokedex/features/pokemon/domain/repositories/locations_repository.dart';

import '../../../../core/exceptions/exceptions.dart';
import '../../../../core/exceptions/failures.dart' as failures;
import '../../../../core/logging/log_event.dart';
import '../../../../core/logging/logger.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/entities/pokemon_details.dart';
import '../../domain/entities/pokemon_location.dart';
import '../../domain/entities/region_map.dart';
import '../../domain/repositories/pokemon_repository.dart';
import '../../domain/value_objects/filters.dart';
import '../../domain/value_objects/sorting.dart';
import '../datasources/map_local_datasource.dart';
import '../datasources/pokemon_graphql_datasource.dart';
import '../dtos/details_dto.dart';

@LazySingleton(as: PokemonRepository)
class PokemonRepositoryImpl implements PokemonRepository, LocationsRepository {
  final PokemonGraphQLDataSource dataSource;
  final MapLocalDataSource mapDataSource;
  final Logger logger;

  PokemonRepositoryImpl(this.dataSource, this.mapDataSource, this.logger);

  static int _counter = 0;

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
  Future<Result<PokemonDetails>> getPokemonDetails(int id) async {
    return _handleRepositoryCall(
      operation: 'getPokemonDetails',
      call: () async {
        final result = await dataSource.getPokemonDetails(id);
        if (result == null) {
          throw const failures.ServerFailure('Pokemon not found');
        }
        return DetailsDto.fromJson(result).toDomainDetails();
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

  @override
  Future<Result<List<PokemonLocation>>> getPokemonLocations(
    int pokemonId,
  ) async {
    return _handleRepositoryCall(
      operation: 'getPokemonLocations',
      call: () async {
        final locationDtos = await dataSource.getPokemonLocations(pokemonId);
        return locationDtos.map((dto) => dto.toDomain()).toList();
      },
    );
  }

  @override
  Future<Result<RegionMap>> loadRegionMap(String regionName) async {
    return _handleRepositoryCall(
      operation: 'loadRegionMap',
      call: () async {
        try {
          final result = await mapDataSource.loadRegionMap(regionName);
          return result.toDomain();
        } on CacheException catch (e) {
          throw failures.CacheFailure(e.message);
        }
      },
    );
  }

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
