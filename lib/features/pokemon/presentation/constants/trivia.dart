import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class TriviaConstants {
  TriviaConstants._();

  // Game Configuration
  static const int timerDurationSeconds = 10;
  static const int minPokemonId = 1;
  static const int maxPokemonId = 1000;

  // Level Configuration
  static const Map<int, TriviaLevelConfig> levelConfigs = {
    1: TriviaLevelConfig(
      level: 1,
      optionCount: 2,
      points: 10,
      silhouetteOpacity: 0.6,
      color: AppColors.successLight,
      borderColor: AppColors.success,
    ),
    2: TriviaLevelConfig(
      level: 2,
      optionCount: 3,
      points: 20,
      silhouetteOpacity: 0.6,
      color: AppColors.warningLight,
      borderColor: AppColors.warning,
    ),
    3: TriviaLevelConfig(
      level: 3,
      optionCount: 4,
      points: 30,
      silhouetteOpacity: 1.0,
      color: AppColors.errorLight,
      borderColor: AppColors.error,
    ),
    4: TriviaLevelConfig(
      level: 4,
      optionCount: 5,
      points: 40,
      silhouetteOpacity: 1.0,
      color: AppColors.infoLight,
      borderColor: AppColors.info,
    ),
    5: TriviaLevelConfig(
      level: 5,
      optionCount: 6,
      points: 50,
      silhouetteOpacity: 1.0,
      color: Color(0xFFF3E5F5),
      borderColor: Color(0xFF9C27B0),
    ),
  };

  // Timer Colors
  static Color getTimerColor(int secondsRemaining) {
    if (secondsRemaining >= 7) {
      return AppColors.success; // Green
    } else if (secondsRemaining >= 4) {
      return AppColors.warning; // Orange
    } else {
      return AppColors.error; // Red
    }
  }

  // Answer Button Colors
  static const Color answerButtonDefault = AppColors.grey300;
  static const Color answerButtonSelected = AppColors.info;
  static const Color answerButtonCorrect = AppColors.success;
  static const Color answerButtonWrong = AppColors.error;

  // UI Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  // UI Sizing
  static const double levelButtonHeight = 60.0;
  static const double answerButtonHeight = 48.0;
  static const double borderRadius = 12.0;
  static const double silhouetteMaxHeight = 300.0;
  static const double timerSize = 60.0;

  static int getAnswerGridColumns(int optionCount) {
    if (optionCount <= 4) {
      return 2;
    } else {
      return 3;
    }
  }

  // Animation Durations
  static const Duration fadeAnimationDuration = Duration(milliseconds: 300);
  static const Duration scaleAnimationDuration = Duration(milliseconds: 200);
  static const Duration pulseAnimationDuration = Duration(milliseconds: 500);
}

class TriviaLevelConfig {
  final int level;
  final int optionCount;
  final int points;
  final double silhouetteOpacity;
  final Color color;
  final Color borderColor;

  const TriviaLevelConfig({
    required this.level,
    required this.optionCount,
    required this.points,
    required this.silhouetteOpacity,
    required this.color,
    required this.borderColor,
  });
}
