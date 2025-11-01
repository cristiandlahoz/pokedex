import 'package:equatable/equatable.dart';

abstract class PokemonEvent extends Equatable {
  const PokemonEvent();

  @override
  List<Object?> get props => [];
}

class LoadPokemonList extends PokemonEvent {
  final int page;
  final int limit;
  final bool isRefresh;

  const LoadPokemonList({
    this.page = 0,
    this.limit = 20,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [page, limit, isRefresh];
}

class LoadMorePokemon extends PokemonEvent {
  const LoadMorePokemon();
}

class SearchPokemonEvent extends PokemonEvent {
  final String query;

  const SearchPokemonEvent(this.query);

  @override
  List<Object?> get props => [query];
}
