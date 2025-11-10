// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:pokedex/core/graphql/graphql_config.dart' as _i1008;
import 'package:pokedex/core/graphql/graphql_service.dart' as _i403;
import 'package:pokedex/features/pokemon/data/datasources/pokemon_graphql_datasource.dart'
    as _i716;
import 'package:pokedex/features/pokemon/data/repositories/pokemon_repository_impl.dart'
    as _i337;
import 'package:pokedex/features/pokemon/domain/repositories/pokemon_repository.dart'
    as _i896;
import 'package:pokedex/features/pokemon/domain/usecases/get_pokemon_details.dart'
    as _i261;
import 'package:pokedex/features/pokemon/domain/usecases/get_pokemon_list.dart'
    as _i680;
import 'package:pokedex/features/pokemon/domain/usecases/search_pokemon.dart'
    as _i1058;
import 'package:pokedex/features/pokemon/presentation/bloc/pokemon_bloc.dart'
    as _i563;
import 'package:pokedex/features/pokemon/presentation/bloc/pokemon_details_bloc.dart'
    as _i202;

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
    gh.factory<_i1008.GraphQLConfig>(() => _i1008.GraphQLConfig());
    gh.lazySingleton<_i403.GraphQLService>(
        () => _i403.GraphQLService(gh<_i1008.GraphQLConfig>()));
    gh.factory<_i716.PokemonGraphQLDataSource>(
        () => _i716.PokemonGraphQLDataSource(gh<_i403.GraphQLService>()));
    gh.lazySingleton<_i896.PokemonRepository>(() =>
        _i337.PokemonRepositoryImpl(gh<_i716.PokemonGraphQLDataSource>()));
    gh.factory<_i1058.SearchPokemon>(
        () => _i1058.SearchPokemon(gh<_i896.PokemonRepository>()));
    gh.factory<_i680.GetPokemonList>(
        () => _i680.GetPokemonList(gh<_i896.PokemonRepository>()));
    gh.factory<_i261.GetPokemonDetails>(
        () => _i261.GetPokemonDetails(gh<_i896.PokemonRepository>()));
    gh.factory<_i563.PokemonBloc>(() => _i563.PokemonBloc(
          getPokemonList: gh<_i680.GetPokemonList>(),
          searchPokemon: gh<_i1058.SearchPokemon>(),
        ));
    gh.factory<_i202.PokemonDetailsBloc>(() => _i202.PokemonDetailsBloc(
        getPokemonDetails: gh<_i261.GetPokemonDetails>()));
    return this;
  }
}
