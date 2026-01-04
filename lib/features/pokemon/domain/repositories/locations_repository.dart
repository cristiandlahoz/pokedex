import '../../../../core/utils/result.dart';
import '../entities/pokemon_location.dart';
import '../entities/region_map.dart';

abstract class LocationsRepository {
  Future<Result<List<PokemonLocation>>> getPokemonLocations(int pokemonId);

  Future<Result<RegionMap>> loadRegionMap(String regionName);
}
