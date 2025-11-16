import 'package:equatable/equatable.dart';
import '../../../core/exceptions/failures.dart';
import '../domain/entities/pokemon.dart';
import '../domain/value_objects/filters.dart';
import '../domain/value_objects/sorting.dart';

sealed class ListState extends Equatable {
  const ListState();

  @override
  List<Object?> get props => [];
}

class ListInitial extends ListState {
  const ListInitial();
}

class ListLoading extends ListState {
  const ListLoading();
}

class ListSuccess extends ListState {
  final List<Pokemon> pokemons;
  final bool hasReachedMax;
  final int currentPage;
  final Sorting sort;
  final Filters filter;

  const ListSuccess({
    required this.pokemons,
    this.hasReachedMax = false,
    this.currentPage = 0,
    this.sort = Sorting.defaultCriteria,
    this.filter = Filters.empty,
  });

  ListSuccess copyWith({
    List<Pokemon>? pokemons,
    bool? hasReachedMax,
    int? currentPage,
    Sorting? sort,
    Filters? filter,
  }) {
    return ListSuccess(
      pokemons: pokemons ?? this.pokemons,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      sort: sort ?? this.sort,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => [
    pokemons,
    hasReachedMax,
    currentPage,
    sort,
    filter,
  ];
}

class ListLoadingMore extends ListSuccess {
  const ListLoadingMore({
    required super.pokemons,
    required super.currentPage,
    required super.sort,
    required super.filter,
  });
}

class ListLoadMoreFailure extends ListSuccess {
  final Failure failure;

  const ListLoadMoreFailure({
    required super.pokemons,
    required super.currentPage,
    required super.sort,
    required super.filter,
    required this.failure,
  });

  @override
  List<Object?> get props => [pokemons, currentPage, sort, filter, failure];
}

class ListFailure extends ListState {
  final Failure failure;

  const ListFailure(this.failure);

  @override
  List<Object?> get props => [failure];
}
