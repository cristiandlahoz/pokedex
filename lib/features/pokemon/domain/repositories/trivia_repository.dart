import '../../../../core/utils/result.dart';
import '../entities/trivia_player.dart';
import '../entities/trivia_question.dart';

abstract class TriviaRepository {
  Future<Result<TriviaQuestion>> generateQuestion(int level);

  Future<Result<TriviaPlayer?>> getPlayer(String name);

  Future<Result<List<TriviaPlayer>>> getAllPlayers();

  Future<Result<void>> savePlayer(TriviaPlayer player);

  Future<Result<TriviaPlayer>> updateStats({
    required String playerName,
    required int level,
    required bool isCorrect,
  });

  Future<Result<void>> deletePlayer(String name);
}
