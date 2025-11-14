import 'package:equatable/equatable.dart';
import '../entities/pokemon_types.dart';
import '../entities/pokemon_generation.dart';

class Filters extends Equatable {
  final List<PokemonTypes> types;
  final List<PokemonGeneration> generations;

  const Filters({
    this.types = const [],
    this.generations = const [],
  });

  bool get isEmpty => types.isEmpty && generations.isEmpty;
  bool get isNotEmpty => !isEmpty;

  int get activeFilterCount => types.length + generations.length;

  bool get hasTypeFilters => types.isNotEmpty;
  bool get hasGenerationFilters => generations.isNotEmpty;

  Filters copyWith({
    List<PokemonTypes>? types,
    List<PokemonGeneration>? generations,
  }) {
    return Filters(
      types: types ?? this.types,
      generations: generations ?? this.generations,
    );
  }

  static const empty = Filters();

  @override
  List<Object?> get props => [types, generations];
}
