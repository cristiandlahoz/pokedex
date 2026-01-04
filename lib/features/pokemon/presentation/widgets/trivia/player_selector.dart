import 'package:flutter/material.dart';

import '../../../../../core/i18n/arb/app_localizations.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/trivia_player.dart';
import '../../constants/trivia.dart';

class PlayerSelector extends StatelessWidget {
  final List<TriviaPlayer> players;
  final TriviaPlayer? currentPlayer;
  final Function(String)? onPlayerChanged;
  final Function(String)? onAddPlayer;

  const PlayerSelector({
    super.key,
    required this.players,
    this.currentPlayer,
    this.onPlayerChanged,
    this.onAddPlayer,
  });

  void _showAddPlayerDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    String? errorMessage;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.triviaAddPlayer),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: l10n.triviaPlayerName,
                  hintText: l10n.triviaPlayerNameHint,
                  errorText: errorMessage,
                ),
                autofocus: true,
                onChanged: (_) {
                  if (errorMessage != null) {
                    setState(() => errorMessage = null);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.triviaCancel),
            ),
            TextButton(
              onPressed: () {
                final name = controller.text.trim();
                if (name.isEmpty) {
                  setState(() => errorMessage = l10n.triviaPlayerNameEmpty);
                  return;
                }

                if (players.any((p) => p.name == name)) {
                  setState(() => errorMessage = l10n.triviaPlayerNameDuplicate);
                  return;
                }

                Navigator.pop(context);
                onAddPlayer?.call(name);
              },
              child: Text(l10n.triviaCreate),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: screenWidth * 0.85),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (players.isNotEmpty)
              DropdownButtonFormField<String>(
                initialValue: currentPlayer?.name,
                decoration: InputDecoration(
                  labelText: l10n.triviaSelectPlayer,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      TriviaConstants.borderRadius,
                    ),
                    borderSide: const BorderSide(
                      color: AppColors.grey500,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      TriviaConstants.borderRadius,
                    ),
                    borderSide: const BorderSide(
                      color: AppColors.grey400,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      TriviaConstants.borderRadius,
                    ),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  isDense: true,
                ),
                items: players.map((player) {
                  return DropdownMenuItem(
                    value: player.name,
                    child: Text(player.name),
                  );
                }).toList(),
                onChanged: (name) {
                  if (name != null) {
                    onPlayerChanged?.call(name);
                  }
                },
              ),
            const SizedBox(height: TriviaConstants.paddingMedium),
            ElevatedButton.icon(
              onPressed: () => _showAddPlayerDialog(context),
              icon: const Icon(Icons.person_add),
              label: Text(l10n.triviaAddPlayer),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(TriviaConstants.paddingMedium),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    TriviaConstants.borderRadius,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
