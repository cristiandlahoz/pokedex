// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:pokedex/core/di/injection_container.dart' as _i416;
import 'package:pokedex/core/graphql/graphql_config.dart' as _i1008;
import 'package:pokedex/core/graphql/graphql_service.dart' as _i403;
import 'package:pokedex/core/logging/logger.dart' as _i1052;
import 'package:pokedex/features/pokemon/bloc/details_bloc.dart' as _i477;
import 'package:pokedex/features/pokemon/bloc/home_bloc.dart' as _i314;
import 'package:pokedex/features/pokemon/data/datasources/pokemon_graphql_datasource.dart'
    as _i716;
import 'package:pokedex/features/pokemon/data/repositories/pokemon_repository_impl.dart'
    as _i337;
import 'package:pokedex/features/pokemon/domain/repositories/pokemon_repository.dart'
    as _i896;
import 'package:pokedex/features/pokemon/domain/services/type_effectiveness_calculator.dart'
    as _i538;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final loggingModule = _$LoggingModule();
    gh.factory<_i538.TypeEffectivenessCalculator>(
      () => _i538.TypeEffectivenessCalculator(),
    );
    gh.lazySingleton<_i1052.Logger>(() => loggingModule.provideLogger());
    gh.lazySingleton<_i1008.GraphQLConfig>(() => _i1008.GraphQLConfig());
    gh.lazySingleton<_i403.GraphQLService>(
      () => _i403.GraphQLService(gh<_i1008.GraphQLConfig>()),
    );
    gh.lazySingleton<_i716.PokemonGraphQLDataSource>(
      () => _i716.PokemonGraphQLDataSource(gh<_i403.GraphQLService>()),
    );
    gh.lazySingleton<_i896.PokemonRepository>(
      () => _i337.PokemonRepositoryImpl(
        gh<_i716.PokemonGraphQLDataSource>(),
        gh<_i1052.Logger>(),
      ),
    );
    gh.factory<_i477.DetailsBloc>(
      () => _i477.DetailsBloc(repository: gh<_i896.PokemonRepository>()),
    );
    gh.factory<_i314.ListBloc>(
      () => _i314.ListBloc(repository: gh<_i896.PokemonRepository>()),
    );
    return this;
  }
}

class _$LoggingModule extends _i416.LoggingModule {}
