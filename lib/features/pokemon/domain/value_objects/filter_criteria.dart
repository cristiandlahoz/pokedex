import 'package:equatable/equatable.dart';
import '../entities/pokemon_types.dart';
import '../entities/pokemon_generation.dart';

class FilterCriteria extends Equatable {
  final List<PokemonTypes> types;
  final List<PokemonGeneration> generations;

  const FilterCriteria({
    this.types = const [],
    this.generations = const [],
  });

  bool get isEmpty => types.isEmpty && generations.isEmpty;
  bool get isNotEmpty => !isEmpty;

  int get activeFilterCount => types.length + generations.length;

  bool get hasTypeFilters => types.isNotEmpty;
  bool get hasGenerationFilters => generations.isNotEmpty;

  FilterCriteria copyWith({
    List<PokemonTypes>? types,
    List<PokemonGeneration>? generations,
  }) {
    return FilterCriteria(
      types: types ?? this.types,
      generations: generations ?? this.generations,
    );
  }

  static const empty = FilterCriteria();

  @override
  List<Object?> get props => [types, generations];
}
