import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/exceptions/exceptions.dart';
import '../models/trivia_player_hive_model.dart';

@lazySingleton
class TriviaLocalDataSource {
  static const String _boxName = 'trivia_players';

  Box<TriviaPlayerHiveModel> get _box =>
      Hive.box<TriviaPlayerHiveModel>(_boxName);

  Future<TriviaPlayerHiveModel?> getPlayer(String name) async {
    try {
      return _box.get(name);
    } catch (e) {
      throw CacheException('Failed to get player: $e');
    }
  }

  Future<List<TriviaPlayerHiveModel>> getAllPlayers() async {
    try {
      return _box.values.toList();
    } catch (e) {
      throw CacheException('Failed to get all players: $e');
    }
  }

  Future<void> savePlayer(TriviaPlayerHiveModel player) async {
    try {
      await _box.put(player.name, player);
    } catch (e) {
      throw CacheException('Failed to save player: $e');
    }
  }

  Future<void> deletePlayer(String name) async {
    try {
      await _box.delete(name);
    } catch (e) {
      throw CacheException('Failed to delete player: $e');
    }
  }
}
