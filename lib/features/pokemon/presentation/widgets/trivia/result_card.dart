import 'package:flutter/material.dart';

import '../../../../../core/i18n/arb/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/pokemon.dart';
import '../../../domain/entities/trivia_question.dart';
import '../../constants/trivia.dart';

/// Card showing the result after answering a question
class ResultCard extends StatelessWidget {
  final TriviaQuestion question;
  final Pokemon? userAnswer;
  final bool isCorrect;
  final int pointsEarned;
  final VoidCallback? onNextQuestion;
  final VoidCallback? onViewDetails;
  final VoidCallback? onBackToMenu;

  const ResultCard({
    super.key,
    required this.question,
    this.userAnswer,
    required this.isCorrect,
    required this.pointsEarned,
    this.onNextQuestion,
    this.onViewDetails,
    this.onBackToMenu,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    String message;
    Color messageColor;

    if (userAnswer == null) {
      // Timeout
      message = l10n.triviaTimeout(question.correctPokemon.name);
      messageColor = AppColors.error;
    } else if (isCorrect) {
      message = l10n.triviaCorrect;
      messageColor = AppColors.success;
    } else {
      message = l10n.triviaWrong(question.correctPokemon.name);
      messageColor = AppColors.error;
    }

    return Card(
      margin: const EdgeInsets.all(TriviaConstants.paddingLarge),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TriviaConstants.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(TriviaConstants.paddingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Result message
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: TriviaConstants.paddingLarge,
                vertical: TriviaConstants.paddingMedium,
              ),
              decoration: BoxDecoration(
                color: messageColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(
                  TriviaConstants.borderRadius,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: messageColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (isCorrect) ...[
                    const SizedBox(height: TriviaConstants.paddingSmall),
                    Text(
                      l10n.triviaPoints(pointsEarned),
                      style: TextStyle(fontSize: 16, color: messageColor),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: TriviaConstants.paddingLarge),

            // Pokemon image
            GestureDetector(
              onTap: onViewDetails,
              child: Hero(
                tag: 'pokemon_${question.correctPokemon.id}',
                child: Image.network(
                  question.correctPokemon.imageUrl ?? '',
                  height: 150,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.catching_pokemon,
                      size: 150,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: TriviaConstants.paddingMedium),

            Text(
              question.correctPokemon.displayName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: TriviaConstants.paddingLarge),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onBackToMenu,
                    child: Text(l10n.triviaBackToMenu),
                  ),
                ),
                const SizedBox(width: TriviaConstants.paddingMedium),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onNextQuestion,
                    child: Text(l10n.triviaNextQuestion),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TriviaConstants.paddingSmall),
            TextButton(
              onPressed: onViewDetails,
              child: Text(l10n.triviaViewDetails),
            ),
          ],
        ),
      ),
    );
  }
}
