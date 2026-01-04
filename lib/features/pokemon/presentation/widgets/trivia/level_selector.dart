import 'package:flutter/material.dart';

import '../../../../../core/i18n/arb/app_localizations.dart';
import '../../constants/trivia.dart';

/// Level difficulty selector widget
class LevelSelector extends StatelessWidget {
  final int currentLevel;
  final Function(int)? onLevelChanged;

  const LevelSelector({
    super.key,
    required this.currentLevel,
    this.onLevelChanged,
  });

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
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.triviaSelectLevel,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: TriviaConstants.paddingLarge),
        ...TriviaConstants.levelConfigs.entries.map((entry) {
          final level = entry.key;
          final config = entry.value;
          final isSelected = level == currentLevel;

          return Padding(
            padding: const EdgeInsets.only(
              bottom: TriviaConstants.paddingMedium,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onLevelChanged != null
                    ? () => onLevelChanged!(level)
                    : null,
                borderRadius: BorderRadius.circular(
                  TriviaConstants.borderRadius,
                ),
                child: Container(
                  height: TriviaConstants.levelButtonHeight,
                  padding: const EdgeInsets.all(TriviaConstants.paddingMedium),
                  decoration: BoxDecoration(
                    color: config.color,
                    borderRadius: BorderRadius.circular(
                      TriviaConstants.borderRadius,
                    ),
                    border: Border.all(
                      color: isSelected
                          ? config.borderColor
                          : Colors.transparent,
                      width: 3,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _getLevelName(context, level),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w600,
                          color: config.borderColor,
                        ),
                      ),
                      Text(
                        '${config.optionCount} options • ${config.points} pts',
                        style: TextStyle(
                          fontSize: 14,
                          color: config.borderColor.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
