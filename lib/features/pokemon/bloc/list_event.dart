import 'package:equatable/equatable.dart';
import '../../../core/theme/tokens.dart';
import '../domain/value_objects/filters.dart';
import '../domain/value_objects/sorting.dart';

sealed class ListEvent extends Equatable {
  const ListEvent();

  @override
  List<Object?> get props => [];
}

class ListLoadRequested extends ListEvent {
  final int page;
  final int limit;
  final bool isRefresh;

  const ListLoadRequested({
    this.page = 0,
    this.limit = DesignTokens.defaultPageSize,
    this.isRefresh = false,
  });

  @override
  List<Object?> get props => [page, limit, isRefresh];
}

class ListLoadMoreRequested extends ListEvent {
  const ListLoadMoreRequested();
}

class ListSearchSubmitted extends ListEvent {
  final String query;

  const ListSearchSubmitted(this.query);

  @override
  List<Object?> get props => [query];
}

class ListSortApplied extends ListEvent {
  final Sorting sort;

  const ListSortApplied(this.sort);

  @override
  List<Object?> get props => [sort];
}

class ListFilterApplied extends ListEvent {
  final Filters filter;

  const ListFilterApplied(this.filter);

  @override
  List<Object?> get props => [filter];
}

class ListFiltersCleared extends ListEvent {
  const ListFiltersCleared();
}
