import 'package:equatable/equatable.dart';
import '../../../../core/exceptions/failures.dart';
import '../../domain/entities/pokemon.dart';

abstract class PokemonDetailsState extends Equatable {
  const PokemonDetailsState();

  @override
  List<Object?> get props => [];
}

class PokemonDetailsInitial extends PokemonDetailsState {
  const PokemonDetailsInitial();
}

class PokemonDetailsLoading extends PokemonDetailsState {
  const PokemonDetailsLoading();
}

class PokemonDetailsLoaded extends PokemonDetailsState {
  final Pokemon pokemon;

  const PokemonDetailsLoaded(this.pokemon);

  @override
  List<Object?> get props => [pokemon];
}

class PokemonDetailsError extends PokemonDetailsState {
  final Failure failure;

  const PokemonDetailsError(this.failure);

  @override
  List<Object?> get props => [failure];
}
