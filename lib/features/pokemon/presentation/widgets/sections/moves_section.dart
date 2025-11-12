import 'package:flutter/material.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../domain/entities/pokemon_move.dart';
import '../../utils/pokemon_type_colors.dart';

class MovesSection extends StatelessWidget {
  static const String _sectionTitle = 'Moves';
  static const String _powerLabel = 'PWR';
  static const String _accuracyLabel = 'ACC';
  static const String _ppLabel = 'PP';
  static const String _accuracySuffix = '%';
  static const String _nameSeparator = '-';
  static const String _nameJoiner = ' ';
  
  static const Color _cardBackgroundColor = Colors.white;
  static const Color _powerColor = Colors.red;
  static const Color _accuracyColor = Colors.blue;
  static const Color _ppColor = Colors.green;
  static const Color _typeBadgeTextColor = Colors.white;

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

  String _formatName(String name) {
    return name
        .split(_nameSeparator)
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(_nameJoiner);
  }

  bool _hasStats(PokemonMove move) {
    return move.power != null || move.accuracy != null || move.pp != null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            _sectionTitle,
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
      children: moves.map(_buildMoveCard).toList(),
    );
  }

  Widget _buildMoveCard(PokemonMove move) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.smallPadding),
      padding: const EdgeInsets.all(AppConstants.mediumPadding),
      decoration: BoxDecoration(
        color: _cardBackgroundColor,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMoveHeader(move),
          if (_hasStats(move)) const SizedBox(height: AppConstants.smallPadding),
          if (_hasStats(move)) _buildMoveStats(move),
        ],
      ),
    );
  }

  Widget _buildMoveHeader(PokemonMove move) {
    return Row(
      children: [
        Expanded(
          child: Text(
            _formatName(move.name),
            style: const TextStyle(
              fontSize: AppConstants.fontSizeLarge,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (move.type != null) _buildTypeBadge(move.type!),
      ],
    );
  }

  Widget _buildTypeBadge(String type) {
    final color = PokemonTypeColors.getColor(type);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.smallPadding,
        vertical: AppConstants.chipVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppConstants.largeBorderRadius),
      ),
      child: Text(
        _formatName(type),
        style: const TextStyle(
          fontSize: AppConstants.fontSizeSmall,
          fontWeight: FontWeight.bold,
          color: _typeBadgeTextColor,
        ),
      ),
    );
  }

  Widget _buildMoveStats(PokemonMove move) {
    final stats = <Widget>[];

    if (move.power != null) {
      stats.add(_buildStatChip(_powerLabel, move.power.toString(), _powerColor));
    }

    if (move.accuracy != null) {
      stats.add(_buildStatChip(_accuracyLabel, '${move.accuracy}$_accuracySuffix', _accuracyColor));
    }

    if (move.pp != null) {
      stats.add(_buildStatChip(_ppLabel, move.pp.toString(), _ppColor));
    }

    return Wrap(
      spacing: AppConstants.chipSpacing,
      runSpacing: AppConstants.chipRunSpacing,
      children: stats,
    );
  }

  Widget _buildStatChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.chipHorizontalPadding,
        vertical: AppConstants.chipVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: AppConstants.opacityLight),
        borderRadius: BorderRadius.circular(AppConstants.chipBorderRadius),
        border: Border.all(color: color.withValues(alpha: AppConstants.opacityBorder)),
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
          const SizedBox(width: AppConstants.chipVerticalPadding),
          Text(
            value,
            style: TextStyle(
              fontSize: AppConstants.fontSizeSmall,
              color: color.withValues(alpha: AppConstants.opacityText),
            ),
          ),
        ],
      ),
    );
  }
}
