import 'package:dartz/dartz.dart';
import '../../../../core/exceptions/failures.dart';
import '../entities/pokemon.dart';
import '../entities/pokemon_details.dart';
import '../../../../core/theme/app_design_tokens.dart';
import '../value_objects/filter_criteria.dart';
import '../value_objects/sort_criteria.dart';

abstract class PokemonRepository {
  Future<Either<Failure, List<Pokemon>>> getPokemonList({
    int page = 0,
    int limit = AppDesignTokens.defaultPageSize,
    SortCriteria? sortCriteria,
    FilterCriteria? filterCriteria,
  });
  Future<Either<Failure, PokemonDetails>> getPokemonDetails(int id);
  Future<Either<Failure, List<Pokemon>>> searchPokemon(String query);
}
