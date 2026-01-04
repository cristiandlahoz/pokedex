import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../constants/trivia.dart';

/// Circular countdown timer widget
class TimerWidget extends StatelessWidget {
  final int secondsRemaining;

  const TimerWidget({super.key, required this.secondsRemaining});

  @override
  Widget build(BuildContext context) {
    final color = TriviaConstants.getTimerColor(secondsRemaining);
    final progress = secondsRemaining / TriviaConstants.timerDurationSeconds;

    return SizedBox(
      width: TriviaConstants.timerSize,
      height: TriviaConstants.timerSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          CircularProgressIndicator(
            value: 1.0,
            strokeWidth: 6,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.grey200),
          ),
          // Progress circle
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 6,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
          // Timer text
          Text(
            '$secondsRemaining',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
