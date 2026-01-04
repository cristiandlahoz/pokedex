import 'package:flutter/material.dart';

import '../../../../../core/i18n/arb/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/trivia_player.dart';
import '../../constants/trivia.dart';

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
