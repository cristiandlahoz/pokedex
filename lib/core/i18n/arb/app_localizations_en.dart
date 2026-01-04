// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get triviaTitle => 'Trivia';

  @override
  String get triviaQuestion => 'Who\'s That Pokémon?';

  @override
  String get triviaCorrect => 'Correct!';

  @override
  String triviaWrong(String pokemonName) {
    return 'Wrong! It was $pokemonName';
  }

  @override
  String triviaTimeout(String pokemonName) {
    return 'Time\'s up! It was $pokemonName';
  }

  @override
  String triviaPoints(int points) {
    return '$points points';
  }

  @override
  String get triviaNextQuestion => 'Next Question';

  @override
  String get triviaBackToMenu => 'Back to Menu';

  @override
  String get triviaViewDetails => 'View Details';

  @override
  String get triviaLevelEasy => 'Easy';

  @override
  String get triviaLevelMedium => 'Medium';

  @override
  String get triviaLevelHard => 'Hard';

  @override
  String get triviaLevelVeryHard => 'Very Hard';

  @override
  String get triviaLevelExpert => 'Expert';

  @override
  String get triviaSelectLevel => 'Select Difficulty';

  @override
  String get triviaSelectPlayer => 'Select Player';

  @override
  String get triviaAddPlayer => 'Add Player';

  @override
  String get triviaPlayerName => 'Player Name';

  @override
  String get triviaPlayerNameHint => 'Enter your name';

  @override
  String get triviaPlayerNameEmpty => 'Please enter a name';

  @override
  String get triviaPlayerNameDuplicate => 'Player already exists';

  @override
  String get triviaCancel => 'Cancel';

  @override
  String get triviaCreate => 'Create';

  @override
  String get triviaStatistics => 'Statistics';

  @override
  String get triviaPlay => 'Play';

  @override
  String get triviaOverallAccuracy => 'Overall Accuracy';

  @override
  String get triviaLevel => 'Level';

  @override
  String get triviaCorrectAnswers => 'Correct';

  @override
  String get triviaWrongAnswers => 'Wrong';

  @override
  String get triviaAccuracy => 'Accuracy';

  @override
  String get triviaStartGame => 'Start Game';

  @override
  String get triviaNoStats => 'No statistics yet. Start playing!';

  @override
  String get triviaLoading => 'Loading...';

  @override
  String get triviaError => 'An error occurred. Please try again.';

  @override
  String get triviaRetry => 'Retry';

  @override
  String get triviaCannotSwitchDuringGame =>
      'Cannot view statistics during active game';
}
