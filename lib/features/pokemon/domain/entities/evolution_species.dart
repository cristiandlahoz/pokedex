import 'package:equatable/equatable.dart';

import 'evolution_requirement.dart';
import 'pokemon_types.dart';

class EvolutionSpecies extends Equatable {
  final int speciesId;
  final String speciesName;
  final int? evolvesFromSpeciesId;
  final int? pokemonId;
  final String? pokemonName;
  final String? imageUrl;
  final List<PokemonTypes> types;
  final List<EvolutionRequirement> requirements;

  const EvolutionSpecies({
    required this.speciesId,
    required this.speciesName,
    required this.types,
    this.evolvesFromSpeciesId,
    this.pokemonId,
    this.pokemonName,
    this.imageUrl,
    this.requirements = const [],
  });

  String get displayName =>
      speciesName[0].toUpperCase() + speciesName.substring(1);

  bool get isBaseForm => evolvesFromSpeciesId == null;

  bool get hasEvolutionRequirements => requirements.isNotEmpty;

  @override
  List<Object?> get props => [
    speciesId,
    speciesName,
    evolvesFromSpeciesId,
    pokemonId,
    pokemonName,
    imageUrl,
    types,
    requirements,
  ];
}
