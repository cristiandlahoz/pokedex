import 'package:equatable/equatable.dart';

sealed class DetailsEvent extends Equatable {
  const DetailsEvent();

  @override
  List<Object?> get props => [];
}

class DetailsLoadRequested extends DetailsEvent {
  final int pokemonId;

  const DetailsLoadRequested(this.pokemonId);

  @override
  List<Object?> get props => [pokemonId];
}
