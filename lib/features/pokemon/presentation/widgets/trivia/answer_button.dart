import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../constants/trivia.dart';

class AnswerButton extends StatelessWidget {
  final String pokemonName;
  final bool isSelected;
  final bool isCorrect;
  final bool isRevealed;
  final VoidCallback? onTap;

  const AnswerButton({
    super.key,
    required this.pokemonName,
    this.isSelected = false,
    this.isCorrect = false,
    this.isRevealed = false,
    this.onTap,
  });

  Color _getBackgroundColor() {
    if (isRevealed) {
      if (isCorrect) {
        return TriviaConstants.answerButtonCorrect;
      } else if (isSelected) {
        return TriviaConstants.answerButtonWrong;
      }
    } else if (isSelected) {
      return TriviaConstants.answerButtonSelected;
    }
    return TriviaConstants.answerButtonDefault;
  }

  Color _getTextColor() {
    if (isRevealed && (isCorrect || isSelected)) {
      return AppColors.textOnPrimary;
    } else if (isSelected) {
      return AppColors.textOnPrimary;
    }
    return AppColors.textPrimary;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _getBackgroundColor();
    final textColor = _getTextColor();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isRevealed ? null : onTap,
        borderRadius: BorderRadius.circular(TriviaConstants.borderRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: TriviaConstants.paddingMedium,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(TriviaConstants.borderRadius),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowMedium,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              pokemonName[0].toUpperCase() + pokemonName.substring(1),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ),
        ),
      ),
    );
  }
}
