import 'package:equatable/equatable.dart';
import '../../domain/entities/pokemon.dart';

abstract class PokemonState extends Equatable {
  const PokemonState();

  @override
  List<Object?> get props => [];
}

class PokemonInitial extends PokemonState {
  const PokemonInitial();
}

class PokemonLoading extends PokemonState {
  const PokemonLoading();
}

class PokemonLoaded extends PokemonState {
  final List<Pokemon> pokemons;
  final bool hasReachedMax;
  final int currentPage;

  const PokemonLoaded({
    required this.pokemons,
    this.hasReachedMax = false,
    this.currentPage = 0,
  });

  PokemonLoaded copyWith({
    List<Pokemon>? pokemons,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return PokemonLoaded(
      pokemons: pokemons ?? this.pokemons,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [pokemons, hasReachedMax, currentPage];
}

class PokemonLoadingMore extends PokemonLoaded {
  const PokemonLoadingMore({
    required super.pokemons,
    required super.currentPage,
  });
}

class PokemonError extends PokemonState {
  final String message;

  const PokemonError(this.message);

  @override
  List<Object?> get props => [message];
}
