// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get triviaTitle => 'Trivia';

  @override
  String get triviaQuestion => '¿Quién es ese Pokémon?';

  @override
  String get triviaCorrect => '¡Correcto!';

  @override
  String triviaWrong(String pokemonName) {
    return '¡Incorrecto! Era $pokemonName';
  }

  @override
  String triviaTimeout(String pokemonName) {
    return '¡Se acabó el tiempo! Era $pokemonName';
  }

  @override
  String triviaPoints(int points) {
    return '$points puntos';
  }

  @override
  String get triviaNextQuestion => 'Siguiente Pregunta';

  @override
  String get triviaBackToMenu => 'Volver al Menú';

  @override
  String get triviaViewDetails => 'Ver Detalles';

  @override
  String get triviaLevelEasy => 'Fácil';

  @override
  String get triviaLevelMedium => 'Medio';

  @override
  String get triviaLevelHard => 'Difícil';

  @override
  String get triviaLevelVeryHard => 'Muy Difícil';

  @override
  String get triviaLevelExpert => 'Experto';

  @override
  String get triviaSelectLevel => 'Seleccionar Dificultad';

  @override
  String get triviaSelectPlayer => 'Seleccionar Jugador';

  @override
  String get triviaAddPlayer => 'Añadir Jugador';

  @override
  String get triviaPlayerName => 'Nombre del Jugador';

  @override
  String get triviaPlayerNameHint => 'Ingresa tu nombre';

  @override
  String get triviaPlayerNameEmpty => 'Por favor ingresa un nombre';

  @override
  String get triviaPlayerNameDuplicate => 'El jugador ya existe';

  @override
  String get triviaCancel => 'Cancelar';

  @override
  String get triviaCreate => 'Crear';

  @override
  String get triviaStatistics => 'Estadísticas';

  @override
  String get triviaPlay => 'Jugar';

  @override
  String get triviaOverallAccuracy => 'Precisión General';

  @override
  String get triviaLevel => 'Nivel';

  @override
  String get triviaCorrectAnswers => 'Correctas';

  @override
  String get triviaWrongAnswers => 'Incorrectas';

  @override
  String get triviaAccuracy => 'Precisión';

  @override
  String get triviaStartGame => 'Iniciar Juego';

  @override
  String get triviaNoStats => 'Sin estadísticas aún. ¡Empieza a jugar!';

  @override
  String get triviaLoading => 'Cargando...';

  @override
  String get triviaError => 'Ocurrió un error. Por favor intenta de nuevo.';

  @override
  String get triviaRetry => 'Reintentar';

  @override
  String get triviaCannotSwitchDuringGame =>
      'No se pueden ver estadísticas durante el juego activo';

  @override
  String get triviaAchievements => 'Logros';

  @override
  String get triviaCurrentBadge => 'Insignia Actual';

  @override
  String get triviaProgressToNext => 'Progreso al siguiente nivel';

  @override
  String triviaMinAnswersRequired(int count) {
    return '¡Responde al menos $count preguntas para desbloquear insignias!';
  }

  @override
  String get triviaBadgePrincipiante => 'Principiante';

  @override
  String get triviaBadgeAprendiz => 'Aprendiz';

  @override
  String get triviaBadgeEntrenador => 'Entrenador';

  @override
  String get triviaBadgeConocedor => 'Conocedor';

  @override
  String get triviaBadgeGranConocedor => 'Gran Conocedor';

  @override
  String get triviaBadgeMaestro => 'Maestro Pokémon';

  @override
  String get triviaBadgeCampeon => 'Campeón';

  @override
  String get triviaMaxRank => '¡Rango máximo alcanzado!';
}
