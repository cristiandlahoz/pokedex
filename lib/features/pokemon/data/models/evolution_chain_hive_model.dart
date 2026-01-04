import 'package:hive/hive.dart';

import '../../domain/entities/evolution_chain.dart';
import 'evolution_species_hive_model.dart';

part 'evolution_chain_hive_model.g.dart';

@HiveType(typeId: 6)
class EvolutionChainHiveModel extends HiveObject {
  @HiveField(0)
  final int chainId;

  @HiveField(1)
  final List<EvolutionSpeciesHiveModel> species;

  EvolutionChainHiveModel({required this.chainId, required this.species});

  factory EvolutionChainHiveModel.fromDomain(EvolutionChain chain) {
    return EvolutionChainHiveModel(
      chainId: chain.chainId,
      species: chain.species
          .map((s) => EvolutionSpeciesHiveModel.fromDomain(s))
          .toList(),
    );
  }

  EvolutionChain toDomain() {
    return EvolutionChain(
      chainId: chainId,
      species: species.map((s) => s.toDomain()).toList(),
    );
  }
}
