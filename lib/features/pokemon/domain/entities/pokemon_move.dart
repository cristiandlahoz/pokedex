import 'package:equatable/equatable.dart';

class PokemonMove extends Equatable {
  final String name;
  final String? type;
  final int? power;
  final int? accuracy;
  final int? pp;

  const PokemonMove({
    required this.name,
    this.type,
    this.power,
    this.accuracy,
    this.pp,
  });

  @override
  List<Object?> get props => [name, type, power, accuracy, pp];
}