import 'package:equatable/equatable.dart';

import 'pokemon.dart';

/// Represents a trivia question with multiple answer options
class TriviaQuestion extends Equatable {
  final Pokemon correctPokemon;
  final List<Pokemon> allOptions;
  final int level;

  const TriviaQuestion({
    required this.correctPokemon,
    required this.allOptions,
    required this.level,
  });

  /// Gets the correct answer (convenience getter)
  Pokemon get correctAnswer => correctPokemon;

  /// Checks if a given Pokemon is the correct answer
  bool isCorrect(Pokemon pokemon) {
    return pokemon.id == correctPokemon.id;
  }

  @override
  List<Object?> get props => [correctPokemon, allOptions, level];
}
