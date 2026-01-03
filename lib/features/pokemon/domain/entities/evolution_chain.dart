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

  EvolutionSpecies? get root {
    try {
      return species.firstWhere((s) => s.isBaseForm);
    } catch (_) {
      return null;
    }
  }

  List<EvolutionSpecies> getEvolutionsOf(int speciesId) {
    return _childrenMap[speciesId] ?? [];
  }

  bool get hasEvolutions => species.length > 1;

  bool get isBranching {
    if (root == null) return false;
    final rootEvolutions = getEvolutionsOf(root!.speciesId);
    return rootEvolutions.length > 1;
  }

  @override
  List<Object?> get props => [chainId, species];
}
