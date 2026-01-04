import 'dart:math';

import 'package:injectable/injectable.dart';

import '../../../../core/exceptions/failures.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/trivia_player.dart';
import '../../domain/entities/trivia_question.dart';
import '../../domain/repositories/trivia_repository.dart';
import '../../presentation/constants/trivia.dart';
import '../datasources/trivia_graphql_datasource.dart';
import '../datasources/trivia_local_datasource.dart';
import '../models/trivia_player_hive_model.dart';

@LazySingleton(as: TriviaRepository)
class TriviaRepositoryImpl implements TriviaRepository {
  final TriviaGraphQLDataSource graphQLDataSource;
  final TriviaLocalDataSource localDataSource;
  final Random _random = Random();

  TriviaRepositoryImpl({
    required this.graphQLDataSource,
    required this.localDataSource,
  });

  @override
  Future<Result<TriviaQuestion>> generateQuestion(int level) async {
    try {
      final levelConfig = TriviaConstants.levelConfigs[level];
      if (levelConfig == null) {
        return const ResultFailure(ServerFailure('Invalid level specified'));
      }

      final pokemon = await graphQLDataSource.getRandomPokemon(
        levelConfig.optionCount,
      );

      if (pokemon.length < levelConfig.optionCount) {
        return const ResultFailure(
          ServerFailure('Failed to generate enough Pokemon for question'),
        );
      }

      final correctIndex = _random.nextInt(pokemon.length);
      final correctPokemon = pokemon[correctIndex];

      final question = TriviaQuestion(
        correctPokemon: correctPokemon,
        allOptions: pokemon,
        level: level,
      );

      return Success(question);
    } on Failure catch (failure) {
      return ResultFailure(failure);
    } catch (e) {
      return ResultFailure(ServerFailure('Failed to generate question: $e'));
    }
  }

  @override
  Future<Result<TriviaPlayer?>> getPlayer(String name) async {
    try {
      final playerModel = await localDataSource.getPlayer(name);
      return Success(playerModel?.toDomain());
    } on Failure catch (failure) {
      return ResultFailure(failure);
    } catch (e) {
      return ResultFailure(CacheFailure('Failed to get player: $e'));
    }
  }

  @override
  Future<Result<List<TriviaPlayer>>> getAllPlayers() async {
    try {
      final playerModels = await localDataSource.getAllPlayers();
      final players = playerModels.map((model) => model.toDomain()).toList();
      return Success(players);
    } on Failure catch (failure) {
      return ResultFailure(failure);
    } catch (e) {
      return ResultFailure(CacheFailure('Failed to get all players: $e'));
    }
  }

  @override
  Future<Result<void>> savePlayer(TriviaPlayer player) async {
    try {
      final playerModel = TriviaPlayerHiveModel.fromDomain(player);
      await localDataSource.savePlayer(playerModel);
      return const Success(null);
    } on Failure catch (failure) {
      return ResultFailure(failure);
    } catch (e) {
      return ResultFailure(CacheFailure('Failed to save player: $e'));
    }
  }

  @override
  Future<Result<TriviaPlayer>> updateStats({
    required String playerName,
    required int level,
    required bool isCorrect,
  }) async {
    try {
      final playerResult = await getPlayer(playerName);

      TriviaPlayer player;
      if (playerResult is Success<TriviaPlayer?>) {
        player =
            playerResult.data ??
            TriviaPlayer(
              name: playerName,
              createdAt: DateTime.now(),
              lastPlayedAt: DateTime.now(),
            );
      } else {
        return ResultFailure((playerResult as ResultFailure).failure);
      }

      final currentStats = player.getStatsForLevel(level);

      final updatedStats = isCorrect
          ? currentStats.incrementCorrect()
          : currentStats.incrementWrong();

      final updatedPlayer = player.updateLevelStats(level, updatedStats);

      final saveResult = await savePlayer(updatedPlayer);
      if (saveResult is ResultFailure) {
        return ResultFailure(saveResult.failure);
      }

      return Success(updatedPlayer);
    } on Failure catch (failure) {
      return ResultFailure(failure);
    } catch (e) {
      return ResultFailure(CacheFailure('Failed to update stats: $e'));
    }
  }

  @override
  Future<Result<void>> deletePlayer(String name) async {
    try {
      await localDataSource.deletePlayer(name);
      return const Success(null);
    } on Failure catch (failure) {
      return ResultFailure(failure);
    } catch (e) {
      return ResultFailure(CacheFailure('Failed to delete player: $e'));
    }
  }
}
