import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/i18n/arb/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../bloc/trivia_bloc.dart';
import '../../../bloc/trivia_event.dart';
import '../../../bloc/trivia_state.dart';
import '../../constants/trivia.dart';
import 'answer_grid.dart';
import 'silhouette_image.dart';
import 'timer_widget.dart';

/// Main question screen showing the silhouette, timer, and answer options
class QuestionScreen extends StatelessWidget {
  const QuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<TriviaBloc, TriviaState>(
      builder: (context, state) {
        if (state is! TriviaQuestionActive) {
          return const SizedBox.shrink();
        }

        final question = state.question;
        final imageUrl = question.correctPokemon.imageUrl ?? '';

        return Column(
          children: [
            // Header with timer and level info
            Container(
              padding: const EdgeInsets.all(TriviaConstants.paddingMedium),
              color: AppColors.backgroundGrey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Level indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: TriviaConstants.paddingMedium,
                      vertical: TriviaConstants.paddingSmall,
                    ),
                    decoration: BoxDecoration(
                      color:
                          TriviaConstants.levelConfigs[question.level]?.color,
                      borderRadius: BorderRadius.circular(
                        TriviaConstants.borderRadius,
                      ),
                    ),
                    child: Text(
                      'Level ${question.level}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: TriviaConstants
                            .levelConfigs[question.level]
                            ?.borderColor,
                      ),
                    ),
                  ),

                  // Timer
                  TimerWidget(secondsRemaining: state.timeRemaining),

                  // Menu button
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      context.read<TriviaBloc>().add(const TriviaBackToMenu());
                    },
                  ),
                ],
              ),
            ),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(TriviaConstants.paddingLarge),
                child: Column(
                  children: [
                    // Question text
                    Text(
                      l10n.triviaQuestion,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: TriviaConstants.paddingLarge),

                    // Silhouette
                    SilhouetteImage(
                      imageUrl: imageUrl,
                      level: question.level,
                      revealed: false,
                    ),
                    const SizedBox(height: TriviaConstants.paddingLarge),

                    // Answer grid
                    AnswerGrid(
                      options: question.allOptions,
                      onAnswerTap: (pokemon) {
                        context.read<TriviaBloc>().add(
                          TriviaAnswerSelected(selectedPokemon: pokemon),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
