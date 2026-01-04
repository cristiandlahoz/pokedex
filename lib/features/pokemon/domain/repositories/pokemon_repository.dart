import '../../../../core/utils/result.dart';
import '../../../../core/theme/tokens.dart';
import '../entities/pokemon.dart';
import '../entities/pokemon_details.dart';
import '../entities/pokemon_location.dart';
import '../entities/region_map.dart';
import '../value_objects/filters.dart';
import '../value_objects/sorting.dart';

abstract class PokemonRepository {
  Future<Result<List<Pokemon>>> getPokemonList({
    int page = 0,
    int limit = DesignTokens.defaultPageSize,
    Sorting? sort,
    Filters? filter,
  });

  Future<Result<PokemonDetails>> getPokemonDetails(int id);

  Future<Result<List<Pokemon>>> searchPokemon(String query);

  Future<Result<List<PokemonLocation>>> getPokemonLocations(int pokemonId);

  Future<Result<RegionMap>> loadRegionMap(String regionName);
}
