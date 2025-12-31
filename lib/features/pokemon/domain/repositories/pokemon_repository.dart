import '../../../../core/utils/result.dart';
import '../entities/pokemon.dart';
import '../entities/pokemon_details.dart';
import '../entities/pokemon_move.dart';
import '../../../../core/theme/tokens.dart';
import '../value_objects/filters.dart';
import '../value_objects/sorting.dart';

abstract class PokemonRepository {
  int get movesPageSize => DesignTokens.defaultMovesLimit;

  Future<Result<List<Pokemon>>> getPokemonList({
    int page = 0,
    int limit = DesignTokens.defaultPageSize,
    Sorting? sort,
    Filters? filter,
  });

  Future<Result<PokemonDetails>> getPokemonDetails(
    int id, {
    int movesPage = 0,
  });

  Future<Result<List<PokemonMove>>> getPokemonMovesPage(
    int id, {
    required int page,
  });

  Future<Result<List<Pokemon>>> searchPokemon(String query);
}
