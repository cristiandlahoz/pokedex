import 'package:hive/hive.dart';

import '../../domain/entities/evolution_species.dart';
import '../../domain/entities/pokemon_types.dart';
import 'evolution_requirement_hive_model.dart';

part 'evolution_species_hive_model.g.dart';

@HiveType(typeId: 7)
class EvolutionSpeciesHiveModel extends HiveObject {
  @HiveField(0)
  final int speciesId;

  @HiveField(1)
  final String speciesName;

  @HiveField(2)
  final int? evolvesFromSpeciesId;

  @HiveField(3)
  final int? pokemonId;

  @HiveField(4)
  final String? pokemonName;

  @HiveField(5)
  final String? imageUrl;

  @HiveField(6)
  final List<int> typeIndices;

  @HiveField(7)
  final List<EvolutionRequirementHiveModel> requirements;

  EvolutionSpeciesHiveModel({
    required this.speciesId,
    required this.speciesName,
    required this.typeIndices,
    this.evolvesFromSpeciesId,
    this.pokemonId,
    this.pokemonName,
    this.imageUrl,
    required this.requirements,
  });

  factory EvolutionSpeciesHiveModel.fromDomain(EvolutionSpecies species) {
    return EvolutionSpeciesHiveModel(
      speciesId: species.speciesId,
      speciesName: species.speciesName,
      evolvesFromSpeciesId: species.evolvesFromSpeciesId,
      pokemonId: species.pokemonId,
      pokemonName: species.pokemonName,
      imageUrl: species.imageUrl,
      typeIndices: species.types.map((t) => t.index).toList(),
      requirements: species.requirements
          .map((r) => EvolutionRequirementHiveModel.fromDomain(r))
          .toList(),
    );
  }

  EvolutionSpecies toDomain() {
    return EvolutionSpecies(
      speciesId: speciesId,
      speciesName: speciesName,
      types: typeIndices.map((i) => PokemonTypes.values[i]).toList(),
      evolvesFromSpeciesId: evolvesFromSpeciesId,
      pokemonId: pokemonId,
      pokemonName: pokemonName,
      imageUrl: imageUrl,
      requirements: requirements.map((r) => r.toDomain()).toList(),
    );
  }
}
