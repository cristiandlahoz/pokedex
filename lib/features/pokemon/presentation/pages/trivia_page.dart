import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/i18n/arb/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/result.dart';
import '../../../../../core/widgets/language_selector.dart';
import '../../bloc/trivia_bloc.dart';
import '../../bloc/trivia_event.dart';
import '../../bloc/trivia_state.dart';
import '../../domain/entities/trivia_player.dart';
import '../constants/trivia.dart';
import '../utils/navigation.dart';
import '../widgets/trivia/level_selector.dart';
import '../widgets/trivia/player_selector.dart';
import '../widgets/trivia/question_screen.dart';
import '../widgets/trivia/result_card.dart';
import '../widgets/trivia/stats_view.dart';

class TriviaPage extends StatefulWidget {
  final Function(String) onLanguageChange;

  const TriviaPage({super.key, required this.onLanguageChange});

  @override
  State<TriviaPage> createState() => _TriviaPageState();
}

class _TriviaPageState extends State<TriviaPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (_tabController.index == 0 && mounted) {
      context.read<TriviaBloc>().add(const TriviaBackToMenu());
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.triviaTitle),
        actions: [
          LanguageSelector(
            currentLanguageCode: Localizations.localeOf(context).languageCode,
            onLanguageChanged: widget.onLanguageChange,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) {
            final state = context.read<TriviaBloc>().state;
            final isGameActive =
                state is TriviaQuestionActive ||
                state is TriviaAnswerRevealed ||
                state is TriviaTimedOut;

            if (index == 1 && isGameActive) {
              _tabController.index = 0;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.triviaCannotSwitchDuringGame),
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          tabs: [
            Tab(text: l10n.triviaPlay),
            Tab(text: l10n.triviaStatistics),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [_GameTab(), _StatisticsTab()],
      ),
    );
  }
}

class _GameTab extends StatelessWidget {
  const _GameTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TriviaBloc, TriviaState>(
      builder: (context, state) {
        return switch (state) {
          TriviaIdle() => _IdleScreen(state: state),
          TriviaLoading() => const Center(child: CircularProgressIndicator()),
          TriviaQuestionActive() => const QuestionScreen(),
          TriviaAnswerRevealed() => _AnswerRevealedScreen(state: state),
          TriviaTimedOut() => _TimedOutScreen(state: state),
          TriviaFailure() => _FailureScreen(state: state),
          TriviaStatsLoaded() => _IdleScreen(
            state: TriviaIdle(currentPlayer: state.player, selectedLevel: 1),
          ),
        };
      },
    );
  }
}

class _IdleScreen extends StatelessWidget {
  final TriviaIdle state;

  const _IdleScreen({required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FutureBuilder<Result<List<TriviaPlayer>>>(
      future: context.read<TriviaBloc>().repository.getAllPlayers(),
      builder: (context, snapshot) {
        final result = snapshot.data;
        List<TriviaPlayer> players = [];

        if (result is Success<List<TriviaPlayer>>) {
          players = result.data;
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(TriviaConstants.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PlayerSelector(
                players: players,
                currentPlayer: state.currentPlayer,
                onPlayerChanged: (name) {
                  context.read<TriviaBloc>().add(
                    TriviaPlayerChanged(playerName: name),
                  );
                },
                onAddPlayer: (name) {
                  context.read<TriviaBloc>().add(
                    TriviaPlayerAdded(playerName: name),
                  );
                },
              ),
              const SizedBox(height: TriviaConstants.paddingLarge),
              LevelSelector(
                currentLevel: state.selectedLevel,
                onLevelChanged: (level) {
                  context.read<TriviaBloc>().add(
                    TriviaLevelChanged(level: level),
                  );
                },
              ),
              const SizedBox(height: TriviaConstants.paddingLarge),
              ElevatedButton(
                onPressed: state.currentPlayer == null
                    ? null
                    : () {
                        context.read<TriviaBloc>().add(
                          TriviaStarted(level: state.selectedLevel),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(TriviaConstants.paddingLarge),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      TriviaConstants.borderRadius,
                    ),
                  ),
                ),
                child: Text(
                  l10n.triviaStartGame,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AnswerRevealedScreen extends StatelessWidget {
  final TriviaAnswerRevealed state;

  const _AnswerRevealedScreen({required this.state});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ResultCard(
        question: state.question,
        userAnswer: state.userAnswer,
        isCorrect: state.isCorrect,
        pointsEarned: state.pointsEarned,
        onNextQuestion: () {
          context.read<TriviaBloc>().add(const TriviaNextQuestionRequested());
        },
        onBackToMenu: () {
          context.read<TriviaBloc>().add(const TriviaBackToMenu());
        },
        onViewDetails: () {
          Navigation.navigateToDetails(
            context: context,
            pokemon: state.question.correctPokemon,
          );
        },
      ),
    );
  }
}

class _TimedOutScreen extends StatelessWidget {
  final TriviaTimedOut state;

  const _TimedOutScreen({required this.state});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ResultCard(
        question: state.question,
        userAnswer: null,
        isCorrect: false,
        pointsEarned: 0,
        onNextQuestion: () {
          context.read<TriviaBloc>().add(const TriviaNextQuestionRequested());
        },
        onBackToMenu: () {
          context.read<TriviaBloc>().add(const TriviaBackToMenu());
        },
        onViewDetails: () {
          Navigation.navigateToDetails(
            context: context,
            pokemon: state.question.correctPokemon,
          );
        },
      ),
    );
  }
}

class _FailureScreen extends StatelessWidget {
  final TriviaFailure state;

  const _FailureScreen({required this.state});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TriviaConstants.paddingLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: TriviaConstants.paddingMedium),
            Text(
              l10n.triviaError,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TriviaConstants.paddingLarge),
            ElevatedButton(
              onPressed: () {
                context.read<TriviaBloc>().add(const TriviaBackToMenu());
              },
              child: Text(l10n.triviaBackToMenu),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatisticsTab extends StatefulWidget {
  const _StatisticsTab();

  @override
  State<_StatisticsTab> createState() => _StatisticsTabState();
}

class _StatisticsTabState extends State<_StatisticsTab> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TriviaBloc, TriviaState>(
      builder: (context, state) {
        if (state is TriviaStatsLoaded) {
          return StatsView(player: state.player);
        } else if (state is TriviaIdle && state.currentPlayer != null) {
          final bloc = context.read<TriviaBloc>();
          Future.microtask(() {
            if (mounted) {
              bloc.add(const TriviaStatsRequested());
            }
          });
          return const Center(child: CircularProgressIndicator());
        } else {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(TriviaConstants.paddingLarge),
              child: Text(
                'Please select a player to view statistics',
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
      },
    );
  }
}
