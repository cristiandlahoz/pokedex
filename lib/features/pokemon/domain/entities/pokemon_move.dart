import 'package:equatable/equatable.dart';

class PokemonMove extends Equatable {
  final String name;

  const PokemonMove({
    required this.name,
  });

  @override
  List<Object?> get props => [name];
}