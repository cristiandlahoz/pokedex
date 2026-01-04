import 'package:flutter/material.dart';

import '../../../domain/entities/pokemon.dart';
import '../../constants/trivia.dart';
import 'answer_button.dart';

class AnswerGrid extends StatelessWidget {
  final List<Pokemon> options;
  final Pokemon? selectedPokemon;
  final Pokemon? correctPokemon;
  final bool isRevealed;
  final Function(Pokemon)? onAnswerTap;

  const AnswerGrid({
    super.key,
    required this.options,
    this.selectedPokemon,
    this.correctPokemon,
    this.isRevealed = false,
    this.onAnswerTap,
  });

  @override
  Widget build(BuildContext context) {
    final columns = TriviaConstants.getAnswerGridColumns(options.length);
    final aspectRatio = columns == 2 ? 3.2 : 2.2;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: TriviaConstants.paddingSmall,
        mainAxisSpacing: TriviaConstants.paddingSmall,
        childAspectRatio: aspectRatio,
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final pokemon = options[index];
        final isSelected = selectedPokemon?.id == pokemon.id;
        final isCorrect = correctPokemon?.id == pokemon.id;

        return AnswerButton(
          pokemonName: pokemon.name,
          isSelected: isSelected,
          isCorrect: isCorrect,
          isRevealed: isRevealed,
          onTap: onAnswerTap != null ? () => onAnswerTap!(pokemon) : null,
        );
      },
    );
  }
}
