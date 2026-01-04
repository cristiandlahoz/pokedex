import 'package:flutter/material.dart';

class TriviaBadge {
  final String nameKey;
  final double minAccuracy;
  final double maxAccuracy;
  final IconData icon;
  final List<Color> gradientColors;
  final Color iconColor;

  const TriviaBadge({
    required this.nameKey,
    required this.minAccuracy,
    required this.maxAccuracy,
    required this.icon,
    required this.gradientColors,
    required this.iconColor,
  });
}

class TriviaBadgeConfig {
  TriviaBadgeConfig._();

  static const int minAnswersRequired = 10;

  static const List<TriviaBadge> badges = [
    TriviaBadge(
      nameKey: 'triviaBadgePrincipiante',
      minAccuracy: 0,
      maxAccuracy: 20,
      icon: Icons.school,
      gradientColors: [Color(0xFF9E9E9E), Color(0xFF616161)],
      iconColor: Colors.white,
    ),
    TriviaBadge(
      nameKey: 'triviaBadgeAprendiz',
      minAccuracy: 20,
      maxAccuracy: 40,
      icon: Icons.local_library,
      gradientColors: [Color(0xFFCD7F32), Color(0xFF8B4513)],
      iconColor: Colors.white,
    ),
    TriviaBadge(
      nameKey: 'triviaBadgeEntrenador',
      minAccuracy: 40,
      maxAccuracy: 60,
      icon: Icons.fitness_center,
      gradientColors: [Color(0xFF42A5F5), Color(0xFF1976D2)],
      iconColor: Colors.white,
    ),
    TriviaBadge(
      nameKey: 'triviaBadgeConocedor',
      minAccuracy: 60,
      maxAccuracy: 75,
      icon: Icons.auto_awesome,
      gradientColors: [Color(0xFF9C27B0), Color(0xFF6A1B9A)],
      iconColor: Colors.white,
    ),
    TriviaBadge(
      nameKey: 'triviaBadgeGranConocedor',
      minAccuracy: 75,
      maxAccuracy: 85,
      icon: Icons.workspace_premium,
      gradientColors: [Color(0xFFFFA726), Color(0xFFEF6C00)],
      iconColor: Colors.white,
    ),
    TriviaBadge(
      nameKey: 'triviaBadgeMaestro',
      minAccuracy: 85,
      maxAccuracy: 95,
      icon: Icons.emoji_events,
      gradientColors: [Color(0xFFFFD700), Color(0xFFFFA500)],
      iconColor: Colors.white,
    ),
    TriviaBadge(
      nameKey: 'triviaBadgeCampeon',
      minAccuracy: 95,
      maxAccuracy: 100,
      icon: Icons.military_tech,
      gradientColors: [Color(0xFFFFEB3B), Color(0xFF4CAF50)],
      iconColor: Colors.white,
    ),
  ];

  static TriviaBadge? getBadgeForAccuracy(double accuracy) {
    for (final badge in badges) {
      if (accuracy >= badge.minAccuracy && accuracy < badge.maxAccuracy) {
        return badge;
      }
      if (accuracy >= badge.maxAccuracy && badge.maxAccuracy == 100) {
        return badge;
      }
    }
    return null;
  }

  static TriviaBadge? getNextBadge(double accuracy) {
    for (int i = 0; i < badges.length - 1; i++) {
      final currentBadge = badges[i];
      if (accuracy >= currentBadge.minAccuracy &&
          accuracy < currentBadge.maxAccuracy) {
        return badges[i + 1];
      }
    }
    return null;
  }

  static double getProgressToNext(double accuracy) {
    final currentBadge = getBadgeForAccuracy(accuracy);
    final nextBadge = getNextBadge(accuracy);

    if (currentBadge == null || nextBadge == null) {
      return 1.0;
    }

    final range = nextBadge.minAccuracy - currentBadge.minAccuracy;
    final progress = accuracy - currentBadge.minAccuracy;

    return (progress / range).clamp(0.0, 1.0);
  }
}
