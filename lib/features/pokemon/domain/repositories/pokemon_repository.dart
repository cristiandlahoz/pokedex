import 'package:dartz/dartz.dart';
import '../../../../core/exceptions/failures.dart';
import '../entities/pokemon.dart';
import '../entities/pokemon_details.dart';
import '../../../../core/theme/tokens.dart';
import '../value_objects/filters.dart';
import '../value_objects/sorting.dart';

abstract class PokemonRepository {
  Future<Either<Failure, List<Pokemon>>> getPokemonList({
    int page = 0,
    int limit = DesignTokens.defaultPageSize,
    Sorting? sort,
    Filters? filter,
  });
  Future<Either<Failure, PokemonDetails>> getPokemonDetails(int id);
  Future<Either<Failure, List<Pokemon>>> searchPokemon(String query);
}
