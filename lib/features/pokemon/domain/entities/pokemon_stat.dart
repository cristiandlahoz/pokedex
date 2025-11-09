import 'package:equatable/equatable.dart';

class PokemonStat extends Equatable {
  final String name;
  final int baseStat;

  const PokemonStat({
    required this.name,
    required this.baseStat,
  });

  @override
  List<Object?> get props => [name, baseStat];
}