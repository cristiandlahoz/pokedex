import 'package:equatable/equatable.dart';

import 'evolution_species.dart';

class EvolutionChain extends Equatable {
  final int chainId;
  final List<EvolutionSpecies> species;

  late final Map<int, List<EvolutionSpecies>> _childrenMap;

  EvolutionChain({required this.chainId, required this.species}) {
    _childrenMap = _buildChildrenMap();
  }

  Map<int, List<EvolutionSpecies>> _buildChildrenMap() {
    final map = <int, List<EvolutionSpecies>>{};
    for (final species in this.species) {
      if (species.evolvesFromSpeciesId != null) {
        map.putIfAbsent(species.evolvesFromSpeciesId!, () => []).add(species);
      }
    }
    return map;
  }

  List<EvolutionSpecies> getEvolutionsOf(int speciesId) {
    return _childrenMap[speciesId] ?? [];
  }

  bool get hasEvolutions => species.length > 1;

  @override
  List<Object?> get props => [chainId, species];
}
