import 'package:injectable/injectable.dart';

import '../../../../core/exceptions/failures.dart';
import '../../../../core/logging/log_event.dart';
import '../../../../core/logging/logger.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/entities/pokemon_details.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../domain/repositories/pokemon_repository.dart';
import '../../domain/value_objects/filters.dart';
import '../../domain/value_objects/sorting.dart';
import '../datasources/favorites_local_datasource.dart';

@LazySingleton(as: FavoritesRepository)
class FavoritesRepositoryImpl
    implements PokemonRepository, FavoritesRepository {
  final FavoritesLocalDataSource dataSource;
  final Logger logger;

  FavoritesRepositoryImpl({required this.dataSource, required this.logger});

  static int _counter = 0;

  @override
  Future<Result<List<Pokemon>>> getPokemonList({
    int page = 0,
    int limit = DesignTokens.defaultPageSize,
    Sorting? sort,
    Filters? filter,
  }) async {
    return _handleRepositoryCall(
      operation: 'getFavorites',
      call: () async {
        var favorites = dataSource.getFavorites();

        if (filter != null && filter.isNotEmpty) {
          favorites = _applyFilters(favorites, filter);
        }

        if (sort != null && !sort.isDefault) {
          favorites = _applySorting(favorites, sort);
        }

        return favorites;
      },
    );
  }

  @override
  Future<Result<PokemonDetails>> getPokemonDetails(int id) async {
    return _handleRepositoryCall(
      operation: 'getFavoriteDetails',
      call: () async {
        final details = dataSource.getFavoriteDetails(id);
        if (details == null) {
          throw const CacheFailure('Favorite details not found');
        }
        return details;
      },
    );
  }

  @override
  Future<Result<List<Pokemon>>> searchPokemon(String query) async {
    return _handleRepositoryCall(
      operation: 'searchFavorites',
      call: () async {
        final favorites = dataSource.getFavorites();
        final queryLower = query.toLowerCase();
        return favorites
            .where(
              (p) =>
                  p.name.toLowerCase().contains(queryLower) ||
                  p.id.toString() == query,
            )
            .toList();
      },
    );
  }

  @override
  Future<Result<void>> addFavoriteDetails(PokemonDetails details) async {
    return _handleRepositoryCall(
      operation: 'addFavoriteDetails',
      call: () async {
        await dataSource.addFavoriteDetails(details);
      },
    );
  }

  @override
  Future<Result<void>> removeFavorite(int pokemonId) async {
    return _handleRepositoryCall(
      operation: 'removeFavorite',
      call: () async {
        await dataSource.removeFavorite(pokemonId);
      },
    );
  }

  @override
  Future<Result<bool>> isFavorite(int pokemonId) async {
    return _handleRepositoryCall(
      operation: 'isFavorite',
      call: () async {
        return dataSource.isFavorite(pokemonId);
      },
    );
  }

  @override
  Future<Result<Set<int>>> getFavoriteIds() async {
    return _handleRepositoryCall(
      operation: 'getFavoriteIds',
      call: () async {
        return dataSource.getFavoriteIds();
      },
    );
  }

  List<Pokemon> _applyFilters(List<Pokemon> pokemon, Filters filter) {
    var filtered = pokemon;

    if (filter.hasTypeFilters) {
      filtered = filtered.where((p) {
        return p.types.any((type) => filter.types.contains(type));
      }).toList();
    }

    return filtered;
  }

  List<Pokemon> _applySorting(List<Pokemon> pokemon, Sorting sort) {
    final sorted = List<Pokemon>.from(pokemon);

    sorted.sort((a, b) {
      int comparison;
      switch (sort.field) {
        case SortField.id:
          comparison = a.id.compareTo(b.id);
        case SortField.name:
          comparison = a.name.compareTo(b.name);
        case SortField.height:
          comparison = (a.height ?? 0).compareTo(b.height ?? 0);
        case SortField.weight:
          comparison = (a.weight ?? 0).compareTo(b.weight ?? 0);
        case SortField.baseExperience:
          comparison = a.id.compareTo(b.id);
      }

      return sort.direction == SortDirection.ascending
          ? comparison
          : -comparison;
    });

    return sorted;
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
    } on Failure catch (failure) {
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
