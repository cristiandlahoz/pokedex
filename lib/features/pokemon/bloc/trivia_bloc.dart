import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../core/utils/result.dart';
import '../domain/entities/trivia_player.dart';
import '../domain/repositories/trivia_repository.dart';
import '../presentation/constants/trivia.dart';
import 'trivia_event.dart';
import 'trivia_state.dart';

@injectable
class TriviaBloc extends Bloc<TriviaEvent, TriviaState> {
  final TriviaRepository repository;
  Timer? _timer;
  TriviaPlayer? _currentPlayer;
  int _currentLevel = 1;

  TriviaBloc({required this.repository}) : super(const TriviaIdle()) {
    on<TriviaStarted>(_onTriviaStarted);
    on<TriviaLevelChanged>(_onTriviaLevelChanged);
    on<TriviaAnswerSelected>(_onTriviaAnswerSelected);
    on<TriviaTimerTicked>(_onTriviaTimerTicked);
    on<TriviaTimeout>(_onTriviaTimeout);
    on<TriviaNextQuestionRequested>(_onTriviaNextQuestionRequested);
    on<TriviaPlayerChanged>(_onTriviaPlayerChanged);
    on<TriviaPlayerAdded>(_onTriviaPlayerAdded);
    on<TriviaStatsRequested>(_onTriviaStatsRequested);
    on<TriviaBackToMenu>(_onTriviaBackToMenu);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }

  Future<void> _onTriviaStarted(
    TriviaStarted event,
    Emitter<TriviaState> emit,
  ) async {
    _currentLevel = event.level;
    await _loadQuestion(emit);
  }

  Future<void> _onTriviaLevelChanged(
    TriviaLevelChanged event,
    Emitter<TriviaState> emit,
  ) async {
    _currentLevel = event.level;
    emit(
      TriviaIdle(currentPlayer: _currentPlayer, selectedLevel: _currentLevel),
    );
  }

  Future<void> _onTriviaAnswerSelected(
    TriviaAnswerSelected event,
    Emitter<TriviaState> emit,
  ) async {
    _timer?.cancel();

    final currentState = state;
    if (currentState is! TriviaQuestionActive) return;

    final question = currentState.question;
    final isCorrect = question.isCorrect(event.selectedPokemon);

    final levelConfig = TriviaConstants.levelConfigs[_currentLevel];
    final pointsEarned = isCorrect ? (levelConfig?.points ?? 0) : 0;

    if (_currentPlayer != null) {
      final result = await repository.updateStats(
        playerName: _currentPlayer!.name,
        level: _currentLevel,
        isCorrect: isCorrect,
      );

      if (result is Success<TriviaPlayer>) {
        _currentPlayer = result.data;
      }
    }

    emit(
      TriviaAnswerRevealed(
        question: question,
        userAnswer: event.selectedPokemon,
        isCorrect: isCorrect,
        pointsEarned: pointsEarned,
      ),
    );
  }

  Future<void> _onTriviaTimerTicked(
    TriviaTimerTicked event,
    Emitter<TriviaState> emit,
  ) async {
    final currentState = state;
    if (currentState is! TriviaQuestionActive) return;

    if (event.secondsRemaining > 0) {
      emit(
        TriviaQuestionActive(
          question: currentState.question,
          timeRemaining: event.secondsRemaining,
        ),
      );
    } else {
      add(const TriviaTimeout());
    }
  }

  Future<void> _onTriviaTimeout(
    TriviaTimeout event,
    Emitter<TriviaState> emit,
  ) async {
    _timer?.cancel();

    final currentState = state;
    if (currentState is! TriviaQuestionActive) return;

    if (_currentPlayer != null) {
      final result = await repository.updateStats(
        playerName: _currentPlayer!.name,
        level: _currentLevel,
        isCorrect: false,
      );

      if (result is Success<TriviaPlayer>) {
        _currentPlayer = result.data;
      }
    }

    emit(TriviaTimedOut(question: currentState.question));
  }

  Future<void> _onTriviaNextQuestionRequested(
    TriviaNextQuestionRequested event,
    Emitter<TriviaState> emit,
  ) async {
    await _loadQuestion(emit);
  }

  Future<void> _onTriviaPlayerChanged(
    TriviaPlayerChanged event,
    Emitter<TriviaState> emit,
  ) async {
    final result = await repository.getPlayer(event.playerName);

    switch (result) {
      case Success(:final data):
        _currentPlayer = data;
        emit(
          TriviaIdle(
            currentPlayer: _currentPlayer,
            selectedLevel: _currentLevel,
          ),
        );
      case ResultFailure(:final failure):
        emit(TriviaFailure(failure: failure));
    }
  }

  Future<void> _onTriviaPlayerAdded(
    TriviaPlayerAdded event,
    Emitter<TriviaState> emit,
  ) async {
    final newPlayer = TriviaPlayer(
      name: event.playerName,
      createdAt: DateTime.now(),
      lastPlayedAt: DateTime.now(),
    );

    final result = await repository.savePlayer(newPlayer);

    switch (result) {
      case Success():
        _currentPlayer = newPlayer;
        emit(
          TriviaIdle(
            currentPlayer: _currentPlayer,
            selectedLevel: _currentLevel,
          ),
        );
      case ResultFailure(:final failure):
        emit(TriviaFailure(failure: failure));
    }
  }

  Future<void> _onTriviaStatsRequested(
    TriviaStatsRequested event,
    Emitter<TriviaState> emit,
  ) async {
    if (_currentPlayer == null) {
      emit(const TriviaIdle());
      return;
    }

    final result = await repository.getPlayer(_currentPlayer!.name);

    switch (result) {
      case Success(:final data):
        if (data != null) {
          _currentPlayer = data;
          emit(TriviaStatsLoaded(player: data));
        } else {
          emit(const TriviaIdle());
        }
      case ResultFailure(:final failure):
        emit(TriviaFailure(failure: failure));
    }
  }

  Future<void> _onTriviaBackToMenu(
    TriviaBackToMenu event,
    Emitter<TriviaState> emit,
  ) async {
    _timer?.cancel();
    emit(
      TriviaIdle(currentPlayer: _currentPlayer, selectedLevel: _currentLevel),
    );
  }

  Future<void> _loadQuestion(Emitter<TriviaState> emit) async {
    _timer?.cancel();

    emit(const TriviaLoading());

    final result = await repository.generateQuestion(_currentLevel);

    switch (result) {
      case Success(:final data):
        _startTimer();
        emit(
          TriviaQuestionActive(
            question: data,
            timeRemaining: TriviaConstants.timerDurationSeconds,
          ),
        );
      case ResultFailure(:final failure):
        emit(TriviaFailure(failure: failure));
    }
  }

  void _startTimer() {
    int secondsRemaining = TriviaConstants.timerDurationSeconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      secondsRemaining--;

      if (isClosed) {
        timer.cancel();
        return;
      }

      final currentState = state;
      if (currentState is TriviaQuestionActive) {
        add(TriviaTimerTicked(secondsRemaining: secondsRemaining));
      } else {
        timer.cancel();
      }
    });
  }
}
