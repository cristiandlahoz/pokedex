import 'package:equatable/equatable.dart';
import '../../../../core/exceptions/failures.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/value_objects/filter_criteria.dart';
import '../../domain/value_objects/sort_criteria.dart';

sealed class PokemonState extends Equatable {
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
  final SortCriteria sortCriteria;
  final FilterCriteria filterCriteria;

  const PokemonLoaded({
    required this.pokemons,
    this.hasReachedMax = false,
    this.currentPage = 0,
    this.sortCriteria = SortCriteria.defaultCriteria,
    this.filterCriteria = FilterCriteria.empty,
  });

  PokemonLoaded copyWith({
    List<Pokemon>? pokemons,
    bool? hasReachedMax,
    int? currentPage,
    SortCriteria? sortCriteria,
    FilterCriteria? filterCriteria,
  }) {
    return PokemonLoaded(
      pokemons: pokemons ?? this.pokemons,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      sortCriteria: sortCriteria ?? this.sortCriteria,
      filterCriteria: filterCriteria ?? this.filterCriteria,
    );
  }

  @override
  List<Object?> get props => [pokemons, hasReachedMax, currentPage, sortCriteria, filterCriteria];
}

class PokemonLoadingMore extends PokemonLoaded {
  const PokemonLoadingMore({
    required super.pokemons,
    required super.currentPage,
    required super.sortCriteria,
    required super.filterCriteria,
  });
}

class PokemonLoadMoreError extends PokemonLoaded {
  final Failure failure;
  
  const PokemonLoadMoreError({
    required super.pokemons,
    required super.currentPage,
    required super.sortCriteria,
    required super.filterCriteria,
    required this.failure,
  });
  
  @override
  List<Object?> get props => [pokemons, currentPage, sortCriteria, filterCriteria, failure];
}

class PokemonError extends PokemonState {
  final Failure failure;

  const PokemonError(this.failure);

  @override
  List<Object?> get props => [failure];
}
