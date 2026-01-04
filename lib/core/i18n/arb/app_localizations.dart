import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// Title for the trivia tab
  ///
  /// In en, this message translates to:
  /// **'Trivia'**
  String get triviaTitle;

  /// The trivia question shown above the silhouette
  ///
  /// In en, this message translates to:
  /// **'Who\'s That Pokémon?'**
  String get triviaQuestion;

  /// Message shown when user answers correctly
  ///
  /// In en, this message translates to:
  /// **'Correct!'**
  String get triviaCorrect;

  /// Message shown when user answers incorrectly
  ///
  /// In en, this message translates to:
  /// **'Wrong! It was {pokemonName}'**
  String triviaWrong(String pokemonName);

  /// Message shown when timer expires
  ///
  /// In en, this message translates to:
  /// **'Time\'s up! It was {pokemonName}'**
  String triviaTimeout(String pokemonName);

  /// Points earned for correct answer
  ///
  /// In en, this message translates to:
  /// **'{points} points'**
  String triviaPoints(int points);

  /// Button to load next question
  ///
  /// In en, this message translates to:
  /// **'Next Question'**
  String get triviaNextQuestion;

  /// Button to return to level selection
  ///
  /// In en, this message translates to:
  /// **'Back to Menu'**
  String get triviaBackToMenu;

  /// Button to view Pokemon details page
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get triviaViewDetails;

  /// Level 1 difficulty name
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get triviaLevelEasy;

  /// Level 2 difficulty name
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get triviaLevelMedium;

  /// Level 3 difficulty name
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get triviaLevelHard;

  /// Level 4 difficulty name
  ///
  /// In en, this message translates to:
  /// **'Very Hard'**
  String get triviaLevelVeryHard;

  /// Level 5 difficulty name
  ///
  /// In en, this message translates to:
  /// **'Expert'**
  String get triviaLevelExpert;

  /// Prompt to select difficulty level
  ///
  /// In en, this message translates to:
  /// **'Select Difficulty'**
  String get triviaSelectLevel;

  /// Dropdown label for player selection
  ///
  /// In en, this message translates to:
  /// **'Select Player'**
  String get triviaSelectPlayer;

  /// Button to add new player
  ///
  /// In en, this message translates to:
  /// **'Add Player'**
  String get triviaAddPlayer;

  /// Text field label for player name
  ///
  /// In en, this message translates to:
  /// **'Player Name'**
  String get triviaPlayerName;

  /// Hint text for player name field
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get triviaPlayerNameHint;

  /// Error message when player name is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get triviaPlayerNameEmpty;

  /// Error message when player name already exists
  ///
  /// In en, this message translates to:
  /// **'Player already exists'**
  String get triviaPlayerNameDuplicate;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get triviaCancel;

  /// Create button text
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get triviaCreate;

  /// Tab label for statistics view
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get triviaStatistics;

  /// Tab label for game view
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get triviaPlay;

  /// Label for overall accuracy statistic
  ///
  /// In en, this message translates to:
  /// **'Overall Accuracy'**
  String get triviaOverallAccuracy;

  /// Column header for level in stats table
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get triviaLevel;

  /// Column header for correct answers in stats table
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get triviaCorrectAnswers;

  /// Column header for wrong answers in stats table
  ///
  /// In en, this message translates to:
  /// **'Wrong'**
  String get triviaWrongAnswers;

  /// Column header for accuracy in stats table
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get triviaAccuracy;

  /// Button text to start a new trivia game
  ///
  /// In en, this message translates to:
  /// **'Start Game'**
  String get triviaStartGame;

  /// Message shown when player has no statistics
  ///
  /// In en, this message translates to:
  /// **'No statistics yet. Start playing!'**
  String get triviaNoStats;

  /// Loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get triviaLoading;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
  String get triviaError;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get triviaRetry;

  /// Warning message when trying to switch to statistics during active game
  ///
  /// In en, this message translates to:
  /// **'Cannot view statistics during active game'**
  String get triviaCannotSwitchDuringGame;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
