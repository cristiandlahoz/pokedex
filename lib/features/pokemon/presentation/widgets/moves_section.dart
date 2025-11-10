import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/pokemon_move.dart';

class MovesSection extends StatelessWidget {
  final List<PokemonMove> moves;

  const MovesSection({
    super.key,
    required this.moves,
  });

  factory MovesSection.withSampleData() {
    return const MovesSection(
      moves: [
        PokemonMove(name: 'tackle'),
        PokemonMove(name: 'growl'),
        PokemonMove(name: 'vine-whip'),
        PokemonMove(name: 'razor-leaf'),
        PokemonMove(name: 'poison-powder'),
        PokemonMove(name: 'sleep-powder'),
        PokemonMove(name: 'take-down'),
        PokemonMove(name: 'solar-beam'),
      ],
    );
  }

  String _formatMoveName(String name) {
    return name
        .split('-')
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Moves',
            style: TextStyle(
              fontSize: AppConstants.fontSizeTitle,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.mediumPadding),
          _buildMovesContainer(),
        ],
      ),
    );
  }

  Widget _buildMovesContainer() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.mediumPadding),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: AppConstants.smallPadding),
          _buildMoveChips(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(Icons.sports_martial_arts, color: Colors.green.shade700),
        const SizedBox(width: AppConstants.smallPadding),
        Text(
          'Available Moves (${moves.length})',
          style: TextStyle(
            fontSize: AppConstants.fontSizeLarge,
            fontWeight: FontWeight.bold,
            color: Colors.green.shade900,
          ),
        ),
      ],
    );
  }

  Widget _buildMoveChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: moves.map((move) => _buildMoveChip(_formatMoveName(move.name))).toList(),
    );
  }

  Widget _buildMoveChip(String move) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.smallPadding,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.largeBorderRadius),
        border: Border.all(
          color: Colors.green.shade200,
        ),
      ),
      child: Text(
        move,
        style: TextStyle(
          fontSize: AppConstants.fontSizeMedium,
          color: Colors.green.shade800,
        ),
      ),
    );
  }
}
