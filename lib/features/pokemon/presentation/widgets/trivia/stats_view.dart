import 'package:flutter/material.dart';

import '../../../../../core/i18n/arb/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/trivia_player.dart';
import '../../constants/trivia.dart';
import '../../constants/trivia_badges.dart';

/// Statistics view widget showing player performance
class StatsView extends StatelessWidget {
  final TriviaPlayer player;

  const StatsView({super.key, required this.player});

  String _getLevelName(BuildContext context, int level) {
    final l10n = AppLocalizations.of(context)!;
    switch (level) {
      case 1:
        return l10n.triviaLevelEasy;
      case 2:
        return l10n.triviaLevelMedium;
      case 3:
        return l10n.triviaLevelHard;
      case 4:
        return l10n.triviaLevelVeryHard;
      case 5:
        return l10n.triviaLevelExpert;
      default:
        return 'Level $level';
    }
  }

  String _getBadgeName(BuildContext context, String nameKey) {
    final l10n = AppLocalizations.of(context)!;
    switch (nameKey) {
      case 'triviaBadgePrincipiante':
        return l10n.triviaBadgePrincipiante;
      case 'triviaBadgeAprendiz':
        return l10n.triviaBadgeAprendiz;
      case 'triviaBadgeEntrenador':
        return l10n.triviaBadgeEntrenador;
      case 'triviaBadgeConocedor':
        return l10n.triviaBadgeConocedor;
      case 'triviaBadgeGranConocedor':
        return l10n.triviaBadgeGranConocedor;
      case 'triviaBadgeMaestro':
        return l10n.triviaBadgeMaestro;
      case 'triviaBadgeCampeon':
        return l10n.triviaBadgeCampeon;
      default:
        return nameKey;
    }
  }

  Widget _buildBadgeSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final totalAnswers = player.getTotalCorrect() + player.getTotalWrong();
    final overallAccuracy = player.getOverallAccuracy();

    // Check if minimum answers requirement is met
    if (totalAnswers < TriviaBadgeConfig.minAnswersRequired) {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TriviaConstants.borderRadius),
        ),
        child: Container(
          padding: const EdgeInsets.all(TriviaConstants.paddingLarge),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(TriviaConstants.borderRadius),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.emoji_events,
                    size: 24,
                    color: AppColors.info,
                  ),
                  const SizedBox(width: TriviaConstants.paddingSmall),
                  Text(
                    l10n.triviaAchievements,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TriviaConstants.paddingMedium),
              const Icon(
                Icons.lock_outline,
                size: 48,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: TriviaConstants.paddingSmall),
              Text(
                l10n.triviaMinAnswersRequired(
                  TriviaBadgeConfig.minAnswersRequired,
                ),
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TriviaConstants.paddingSmall),
              Text(
                '$totalAnswers / ${TriviaBadgeConfig.minAnswersRequired}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Get current badge
    final currentBadge = TriviaBadgeConfig.getBadgeForAccuracy(overallAccuracy);
    if (currentBadge == null) return const SizedBox.shrink();

    final nextBadge = TriviaBadgeConfig.getNextBadge(overallAccuracy);
    final progress = TriviaBadgeConfig.getProgressToNext(overallAccuracy);
    final isMaxRank = nextBadge == null;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TriviaConstants.borderRadius),
      ),
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(TriviaConstants.paddingLarge),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: currentBadge.gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(TriviaConstants.borderRadius),
        ),
        child: Column(
          children: [
            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.emoji_events,
                  size: 24,
                  color: currentBadge.iconColor,
                ),
                const SizedBox(width: TriviaConstants.paddingSmall),
                Text(
                  l10n.triviaAchievements,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: currentBadge.iconColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: TriviaConstants.paddingMedium),

            // Badge icon
            Icon(currentBadge.icon, size: 64, color: currentBadge.iconColor),
            const SizedBox(height: TriviaConstants.paddingSmall),

            // Badge name
            Text(
              _getBadgeName(context, currentBadge.nameKey),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: currentBadge.iconColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TriviaConstants.paddingSmall),

            // Accuracy
            Text(
              '${overallAccuracy.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 18,
                color: currentBadge.iconColor.withOpacity(0.9),
              ),
            ),

            // Progress section
            if (!isMaxRank) ...[
              const SizedBox(height: TriviaConstants.paddingMedium),
              Text(
                l10n.triviaProgressToNext,
                style: TextStyle(
                  fontSize: 14,
                  color: currentBadge.iconColor.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: TriviaConstants.paddingSmall),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 12,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withOpacity(0.9),
                  ),
                ),
              ),
              const SizedBox(height: TriviaConstants.paddingSmall),
              Text(
                '${nextBadge!.minAccuracy.toStringAsFixed(0)}% → ${_getBadgeName(context, nextBadge.nameKey)}',
                style: TextStyle(
                  fontSize: 12,
                  color: currentBadge.iconColor.withOpacity(0.8),
                ),
              ),
            ] else ...[
              const SizedBox(height: TriviaConstants.paddingMedium),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: currentBadge.iconColor, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    l10n.triviaMaxRank,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: currentBadge.iconColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.star, color: currentBadge.iconColor, size: 20),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final overallAccuracy = player.getOverallAccuracy();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(TriviaConstants.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Player name
          Text(
            player.name,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: TriviaConstants.paddingLarge),

          // Overall accuracy card
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(TriviaConstants.borderRadius),
            ),
            child: Padding(
              padding: const EdgeInsets.all(TriviaConstants.paddingLarge),
              child: Column(
                children: [
                  Text(
                    l10n.triviaOverallAccuracy,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: TriviaConstants.paddingSmall),
                  Text(
                    '${overallAccuracy.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: TriviaConstants.paddingSmall),
                  Text(
                    '${player.getTotalCorrect()} correct • ${player.getTotalWrong()} wrong',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: TriviaConstants.paddingLarge),

          // Achievement badges section
          _buildBadgeSection(context),
          const SizedBox(height: TriviaConstants.paddingLarge),

          // Per-level statistics
          Text(
            l10n.triviaStatistics,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: TriviaConstants.paddingMedium),

          if (player.levelStats.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(TriviaConstants.paddingLarge),
                child: Text(
                  l10n.triviaNoStats,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            Table(
              border: TableBorder.all(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(
                  TriviaConstants.borderRadius,
                ),
              ),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1.5),
              },
              children: [
                // Header row
                TableRow(
                  decoration: BoxDecoration(
                    color: AppColors.grey100,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(TriviaConstants.borderRadius),
                      topRight: Radius.circular(TriviaConstants.borderRadius),
                    ),
                  ),
                  children: [
                    _buildHeaderCell(l10n.triviaLevel),
                    _buildHeaderCell(l10n.triviaCorrectAnswers),
                    _buildHeaderCell(l10n.triviaWrongAnswers),
                    _buildHeaderCell(l10n.triviaAccuracy),
                  ],
                ),
                // Data rows
                ...List.generate(5, (index) {
                  final level = index + 1;
                  final stats = player.getStatsForLevel(level);
                  final config = TriviaConstants.levelConfigs[level];

                  return TableRow(
                    decoration: BoxDecoration(
                      color: stats.totalAttempts > 0
                          ? config?.color.withOpacity(0.3)
                          : null,
                    ),
                    children: [
                      _buildDataCell(_getLevelName(context, level)),
                      _buildDataCell('${stats.correctAnswers}'),
                      _buildDataCell('${stats.wrongAnswers}'),
                      _buildDataCell(
                        stats.totalAttempts > 0
                            ? '${stats.accuracy.toStringAsFixed(1)}%'
                            : '-',
                      ),
                    ],
                  );
                }),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(TriviaConstants.paddingSmall),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDataCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(TriviaConstants.paddingSmall),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
