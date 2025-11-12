import 'package:equatable/equatable.dart';

class PokemonStat extends Equatable {
  final String name;
  final int baseStat;
  final int effort;

  const PokemonStat({
    required this.name,
    required this.baseStat,
    this.effort = 0,
  });

  int calculateMinStat({int level = 100}) {
    if (name.toLowerCase() == 'hp') {
      return ((2 * baseStat + 0 + 0) * level ~/ 100) + level + 10;
    } else {
      return ((((2 * baseStat + 0 + 0) * level ~/ 100) + 5) * 0.9).floor();
    }
  }

  int calculateMaxStat({int level = 100}) {
    if (name.toLowerCase() == 'hp') {
      return ((2 * baseStat + 31 + 63) * level ~/ 100) + level + 10;
    } else {
      return ((((2 * baseStat + 31 + 63) * level ~/ 100) + 5) * 1.1).floor();
    }
  }

  @override
  List<Object?> get props => [name, baseStat, effort];
}