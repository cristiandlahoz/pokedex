import '../../../../core/utils/result.dart';
import '../entities/pokemon_details.dart';

abstract class FavoritesRepository {
  Future<Result<void>> addFavoriteDetails(PokemonDetails details);

  Future<Result<void>> removeFavorite(int pokemonId);

  Future<Result<bool>> isFavorite(int pokemonId);

  Future<Result<Set<int>>> getFavoriteIds();
}
