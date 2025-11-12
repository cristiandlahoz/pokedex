import 'package:flutter/material.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../domain/entities/pokemon_move.dart';
import '../../utils/pokemon_type_colors.dart';

class MovesSection extends StatelessWidget {
  final List<PokemonMove> moves;

  const MovesSection({
    super.key,
    required this.moves,
  });

  factory MovesSection.withSampleData() {
    return const MovesSection(
      moves: [
        PokemonMove(name: 'tackle', type: 'normal', power: 40, accuracy: 100, pp: 35),
        PokemonMove(name: 'growl', type: 'normal', pp: 40),
        PokemonMove(name: 'vine-whip', type: 'grass', power: 45, accuracy: 100, pp: 25),
        PokemonMove(name: 'razor-leaf', type: 'grass', power: 55, accuracy: 95, pp: 25),
        PokemonMove(name: 'poison-powder', type: 'poison', accuracy: 75, pp: 35),
        PokemonMove(name: 'sleep-powder', type: 'grass', accuracy: 75, pp: 15),
        PokemonMove(name: 'take-down', type: 'normal', power: 90, accuracy: 85, pp: 20),
        PokemonMove(name: 'solar-beam', type: 'grass', power: 120, accuracy: 100, pp: 10),
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
          _buildMovesList(),
        ],
      ),
    );
  }

  Widget _buildMovesList() {
    return Column(
      children: moves.map((move) => _buildMoveCard(move)).toList(),
    );
  }

  Widget _buildMoveCard(PokemonMove move) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      padding: const EdgeInsets.all(AppConstants.mediumPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _formatMoveName(move.name),
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeLarge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (move.type != null) _buildTypeBadge(move.type!),
            ],
          ),
          if (move.power != null || move.accuracy != null || move.pp != null)
            const SizedBox(height: AppConstants.smallPadding),
          if (move.power != null || move.accuracy != null || move.pp != null)
            _buildMoveStats(move),
        ],
      ),
    );
  }

  Widget _buildTypeBadge(String type) {
    final color = PokemonTypeColors.getColor(type);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.smallPadding,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppConstants.largeBorderRadius),
      ),
      child: Text(
        _formatMoveName(type),
        style: const TextStyle(
          fontSize: AppConstants.fontSizeSmall,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildMoveStats(PokemonMove move) {
    final stats = <Widget>[];

    if (move.power != null) {
      stats.add(_buildStatChip('PWR', move.power.toString(), Colors.red));
    }

    if (move.accuracy != null) {
      stats.add(_buildStatChip('ACC', '${move.accuracy}%', Colors.blue));
    }

    if (move.pp != null) {
      stats.add(_buildStatChip('PP', move.pp.toString(), Colors.green));
    }

    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: stats,
    );
  }

  Widget _buildStatChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: AppConstants.fontSizeSmall,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: AppConstants.fontSizeSmall,
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
