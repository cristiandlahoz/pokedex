import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/exceptions/failures.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/entities/pokemon_details.dart';
import '../models/pokemon_details_hive_model.dart';

@lazySingleton
class FavoritesLocalDataSource {
  static const String _boxName = 'favorites';

  Box<PokemonDetailsHiveModel> get _box =>
      Hive.box<PokemonDetailsHiveModel>(_boxName);

  List<Pokemon> getFavorites() {
    try {
      return _box.values.map((model) => model.toDomain()).toList();
    } catch (e) {
      throw CacheFailure('Failed to load favorites: ${e.toString()}');
    }
  }

  PokemonDetails? getFavoriteDetails(int id) {
    try {
      final model = _box.get(id);
      return model?.toDomain();
    } catch (e) {
      throw CacheFailure('Failed to get favorite details: ${e.toString()}');
    }
  }

  Future<void> addFavoriteDetails(PokemonDetails details) async {
    try {
      final model = PokemonDetailsHiveModel.fromDomain(details);
      await _box.put(details.id, model);
    } catch (e) {
      throw CacheFailure('Failed to add favorite details: ${e.toString()}');
    }
  }

  Future<void> removeFavorite(int pokemonId) async {
    try {
      await _box.delete(pokemonId);
    } catch (e) {
      throw CacheFailure('Failed to remove favorite: ${e.toString()}');
    }
  }

  bool isFavorite(int pokemonId) {
    try {
      return _box.containsKey(pokemonId);
    } catch (e) {
      throw CacheFailure('Failed to check favorite status: ${e.toString()}');
    }
  }

  Set<int> getFavoriteIds() {
    try {
      return _box.keys.cast<int>().toSet();
    } catch (e) {
      throw CacheFailure('Failed to get favorite IDs: ${e.toString()}');
    }
  }
}
