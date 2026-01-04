// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:pokedex/core/connectivity/connectivity_bloc.dart' as _i961;
import 'package:pokedex/core/connectivity/connectivity_service.dart' as _i198;
import 'package:pokedex/core/di/injection_container.dart' as _i416;
import 'package:pokedex/core/graphql/graphql_config.dart' as _i1008;
import 'package:pokedex/core/graphql/graphql_service.dart' as _i403;
import 'package:pokedex/core/logging/logger.dart' as _i1052;
import 'package:pokedex/features/pokemon/bloc/details_bloc.dart' as _i477;
import 'package:pokedex/features/pokemon/bloc/favorites_bloc.dart' as _i596;
import 'package:pokedex/features/pokemon/bloc/game_version_bloc.dart' as _i913;
import 'package:pokedex/features/pokemon/bloc/home_bloc.dart' as _i314;
import 'package:pokedex/features/pokemon/bloc/locations_bloc.dart' as _i276;
import 'package:pokedex/features/pokemon/bloc/trivia_bloc.dart' as _i244;
import 'package:pokedex/features/pokemon/data/datasources/favorites_local_datasource.dart'
    as _i25;
import 'package:pokedex/features/pokemon/data/datasources/map_local_datasource.dart'
    as _i339;
import 'package:pokedex/features/pokemon/data/datasources/pokemon_graphql_datasource.dart'
    as _i716;
import 'package:pokedex/features/pokemon/data/datasources/trivia_graphql_datasource.dart'
    as _i154;
import 'package:pokedex/features/pokemon/data/datasources/trivia_local_datasource.dart'
    as _i368;
import 'package:pokedex/features/pokemon/data/repositories/favorites_repository_impl.dart'
    as _i988;
import 'package:pokedex/features/pokemon/data/repositories/pokemon_repository_impl.dart'
    as _i337;
import 'package:pokedex/features/pokemon/data/repositories/trivia_repository_impl.dart'
    as _i830;
import 'package:pokedex/features/pokemon/domain/repositories/favorites_repository.dart'
    as _i56;
import 'package:pokedex/features/pokemon/domain/repositories/locations_repository.dart'
    as _i690;
import 'package:pokedex/features/pokemon/domain/repositories/pokemon_repository.dart'
    as _i896;
import 'package:pokedex/features/pokemon/domain/repositories/trivia_repository.dart'
    as _i295;
import 'package:pokedex/features/pokemon/domain/services/location_matcher.dart'
    as _i17;
import 'package:pokedex/features/pokemon/domain/services/moves_filtering_service.dart'
    as _i1066;
import 'package:pokedex/features/pokemon/domain/services/moves_sorting_service.dart'
    as _i750;
import 'package:pokedex/features/pokemon/domain/services/type_effectiveness_calculator.dart'
    as _i538;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final loggingModule = _$LoggingModule();
    gh.factory<_i1066.MovesFilteringService>(
        () => _i1066.MovesFilteringService());
    gh.factory<_i538.TypeEffectivenessCalculator>(
        () => _i538.TypeEffectivenessCalculator());
    gh.factory<_i17.LocationMatcher>(() => _i17.LocationMatcher());
    gh.factory<_i750.MovesSortingService>(() => _i750.MovesSortingService());
    gh.factory<_i913.GameVersionBloc>(() => _i913.GameVersionBloc());
    gh.lazySingleton<_i1052.Logger>(() => loggingModule.provideLogger());
    gh.lazySingleton<_i198.ConnectivityService>(
        () => _i198.ConnectivityService());
    gh.lazySingleton<_i1008.GraphQLConfig>(() => _i1008.GraphQLConfig());
    gh.lazySingleton<_i25.FavoritesLocalDataSource>(
        () => _i25.FavoritesLocalDataSource());
    gh.lazySingleton<_i368.TriviaLocalDataSource>(
        () => _i368.TriviaLocalDataSource());
    gh.lazySingleton<_i339.MapLocalDataSource>(
        () => _i339.MapLocalDataSource());
    gh.lazySingleton<_i56.FavoritesRepository>(
        () => _i988.FavoritesRepositoryImpl(
              dataSource: gh<_i25.FavoritesLocalDataSource>(),
              logger: gh<_i1052.Logger>(),
            ));
    gh.lazySingleton<_i403.GraphQLService>(
        () => _i403.GraphQLService(gh<_i1008.GraphQLConfig>()));
    gh.factory<_i276.LocationsBloc>(() => _i276.LocationsBloc(
          repository: gh<_i690.LocationsRepository>(),
          locationMatcher: gh<_i17.LocationMatcher>(),
        ));
    gh.lazySingleton<_i716.PokemonGraphQLDataSource>(
        () => _i716.PokemonGraphQLDataSource(gh<_i403.GraphQLService>()));
    gh.lazySingleton<_i154.TriviaGraphQLDataSource>(
        () => _i154.TriviaGraphQLDataSource(gh<_i403.GraphQLService>()));
    gh.factory<_i961.ConnectivityBloc>(
        () => _i961.ConnectivityBloc(service: gh<_i198.ConnectivityService>()));
    gh.lazySingleton<_i896.PokemonRepository>(() => _i337.PokemonRepositoryImpl(
          gh<_i716.PokemonGraphQLDataSource>(),
          gh<_i339.MapLocalDataSource>(),
          gh<_i1052.Logger>(),
        ));
    gh.lazySingleton<_i295.TriviaRepository>(() => _i830.TriviaRepositoryImpl(
          graphQLDataSource: gh<_i154.TriviaGraphQLDataSource>(),
          localDataSource: gh<_i368.TriviaLocalDataSource>(),
        ));
    gh.factory<_i244.TriviaBloc>(
        () => _i244.TriviaBloc(repository: gh<_i295.TriviaRepository>()));
    gh.factory<_i596.FavoritesBloc>(() => _i596.FavoritesBloc(
          favoritesRepository: gh<_i56.FavoritesRepository>(),
          pokemonRepository: gh<_i896.PokemonRepository>(),
        ));
    gh.factory<_i477.DetailsBloc>(
        () => _i477.DetailsBloc(repository: gh<_i896.PokemonRepository>()));
    gh.factory<_i314.ListBloc>(
        () => _i314.ListBloc(repository: gh<_i896.PokemonRepository>()));
    return this;
  }
}

class _$LoggingModule extends _i416.LoggingModule {}
