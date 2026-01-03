import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

import '../../../domain/entities/evolution_chain.dart';
import '../../../domain/entities/evolution_species.dart';
import '../../constants/evolution.dart';
import 'evolution_species_card.dart';

class EvolutionChainWidget extends StatelessWidget {
  final EvolutionChain chain;
  final int currentPokemonId;

  const EvolutionChainWidget({
    super.key,
    required this.chain,
    required this.currentPokemonId,
  });

  double _calculateGraphHeight(int maxVerticalNodes) {
    const double minHeight = 300.0;
    const double maxHeight = 1400.0;
    const double cardHeight = 220.0;
    const double nodeSeparation = 40.0;
    const double extraPadding = 100.0;

    final calculatedHeight =
        (cardHeight * maxVerticalNodes) +
        (nodeSeparation * (maxVerticalNodes - 1)) +
        extraPadding;

    return calculatedHeight.clamp(minHeight, maxHeight);
  }

  int _calculateMaxVerticalNodes() {
    int maxBranching = 1;
    for (final species in chain.species) {
      final evolutions = chain.getEvolutionsOf(species.speciesId);
      if (evolutions.length > maxBranching) {
        maxBranching = evolutions.length;
      }
    }
    return maxBranching;
  }

  @override
  Widget build(BuildContext context) {
    final graph = Graph()..isTree = true;

    // Cache maxVerticalNodes to avoid redundant O(n²) calculation
    final maxVerticalNodes = _calculateMaxVerticalNodes();

    final configuration = SugiyamaConfiguration()
      ..nodeSeparation = 40
      ..levelSeparation = 70
      ..orientation = maxVerticalNodes > 2
          ? SugiyamaConfiguration.ORIENTATION_LEFT_RIGHT
          : SugiyamaConfiguration.ORIENTATION_TOP_BOTTOM;

    final nodeMap = <int, Node>{};

    final speciesMap = <int, EvolutionSpecies>{
      for (final species in chain.species) species.speciesId: species,
    };

    for (final species in chain.species) {
      try {
        //build nodes
        final node = Node.Id(species.speciesId);
        nodeMap[species.speciesId] = node;
        graph.addNode(node);

        //build edges
        if (species.evolvesFromSpeciesId != null) {
          final fromNode = nodeMap[species.evolvesFromSpeciesId];
          final toNode = nodeMap[species.speciesId];
          if (fromNode != null && toNode != null) {
            graph.addEdge(fromNode, toNode);
          }
        }
      } catch (_) {
        continue;
      }
    }

    final graphHeight = _calculateGraphHeight(maxVerticalNodes);

    return SizedBox(
      height: graphHeight,
      child: GraphView.builder(
        graph: graph,
        algorithm: SugiyamaAlgorithm(configuration),
        paint: Paint()
          ..color = EvolutionConstants.timelineColor
          ..strokeWidth = EvolutionConstants.timelineWidth
          ..style = PaintingStyle.fill,
        animated: true,
        autoZoomToFit: true,
        builder: (Node node) {
          final speciesId = node.key!.value as int;
          final species = speciesMap[speciesId]!;

          return EvolutionSpeciesCard(
            species: species,
            isCurrentPokemon: species.pokemonId == currentPokemonId,
          );
        },
      ),
    );
  }
}
