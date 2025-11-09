import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/pokemon.dart';
import 'stat_bar.dart';

class BaseStatsSection extends StatelessWidget {
  final List<PokemonStat> stats;

  const BaseStatsSection({
    super.key,
    required this.stats,
  });

  factory BaseStatsSection.withSampleData() {
    return const BaseStatsSection(
      stats: [
        PokemonStat(name: 'hp', baseStat: 45),
        PokemonStat(name: 'attack', baseStat: 49),
        PokemonStat(name: 'defense', baseStat: 49),
        PokemonStat(name: 'special-attack', baseStat: 65),
        PokemonStat(name: 'special-defense', baseStat: 65),
        PokemonStat(name: 'speed', baseStat: 45),
      ],
    );
  }

  String _formatStatName(String name) {
    switch (name.toLowerCase()) {
      case 'hp':
        return 'HP';
      case 'attack':
        return 'Attack';
      case 'defense':
        return 'Defense';
      case 'special-attack':
        return 'Sp. Atk';
      case 'special-defense':
        return 'Sp. Def';
      case 'speed':
        return 'Speed';
      default:
        return name;
    }
  }

  Color _getStatColor(String name) {
    switch (name.toLowerCase()) {
      case 'hp':
        return Colors.red;
      case 'attack':
        return Colors.orange;
      case 'defense':
        return Colors.blue;
      case 'special-attack':
        return Colors.purple;
      case 'special-defense':
        return Colors.green;
      case 'speed':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Base Stats',
            style: TextStyle(
              fontSize: AppConstants.fontSizeTitle,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.mediumPadding),
          ...stats.map(
            (stat) => StatBar(
              name: _formatStatName(stat.name),
              value: stat.baseStat,
              color: _getStatColor(stat.name),
            ),
          ),
        ],
      ),
    );
  }
}
