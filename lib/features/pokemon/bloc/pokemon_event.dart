import 'package:equatable/equatable.dart';
import '../../../core/theme/app_design_tokens.dart';
import '../domain/value_objects/filter_criteria.dart';
import '../domain/value_objects/sort_criteria.dart';

sealed class PokemonEvent extends Equatable {
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
    this.limit = AppDesignTokens.defaultPageSize,
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

class ApplySortEvent extends PokemonEvent {
  final SortCriteria sortCriteria;

  const ApplySortEvent(this.sortCriteria);

  @override
  List<Object?> get props => [sortCriteria];
}

class ApplyFilterEvent extends PokemonEvent {
  final FilterCriteria filterCriteria;

  const ApplyFilterEvent(this.filterCriteria);

  @override
  List<Object?> get props => [filterCriteria];
}

class ClearFiltersEvent extends PokemonEvent {
  const ClearFiltersEvent();
}
