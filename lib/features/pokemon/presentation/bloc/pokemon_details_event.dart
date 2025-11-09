import 'package:equatable/equatable.dart';

abstract class PokemonDetailsEvent extends Equatable {
  const PokemonDetailsEvent();

  @override
  List<Object?> get props => [];
}

class LoadPokemonDetails extends PokemonDetailsEvent {
  final int pokemonId;

  const LoadPokemonDetails(this.pokemonId);

  @override
  List<Object?> get props => [pokemonId];
}
