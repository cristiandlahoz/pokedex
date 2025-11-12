import 'package:flutter/material.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../domain/entities/pokemon_stat.dart';
import '../shared/stat_bar.dart';
import '../../utils/pokemon_type_colors.dart';

enum StatView { base, min, max }

class BaseStatsSection extends StatefulWidget {
  final List<PokemonStat> stats;
  final String primaryType;

  const BaseStatsSection({
    super.key,
    required this.stats,
    required this.primaryType,
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
      primaryType: 'normal',
    );
  }

  @override
  State<BaseStatsSection> createState() => _BaseStatsSectionState();
}

class _BaseStatsSectionState extends State<BaseStatsSection> {
  StatView _selectedView = StatView.base;

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

  Color _getPrimaryTypeColor() {
    return PokemonTypeColors.getColor(widget.primaryType);
  }


  int _getTotalStats() {
    return widget.stats.map((s) => _getStatValue(s)).reduce((a, b) => a + b);
  }

  int _getStatValue(PokemonStat stat) {
    switch (_selectedView) {
      case StatView.base:
        return stat.baseStat;
      case StatView.min:
        return stat.calculateMinStat();
      case StatView.max:
        return stat.calculateMaxStat();
    }
  }

  int _getMaxValue() {
    switch (_selectedView) {
      case StatView.base:
        return widget.stats.map((s) => s.baseStat).reduce((a, b) => a > b ? a : b);
      case StatView.min:
        return widget.stats.map((s) => s.calculateMinStat()).reduce((a, b) => a > b ? a : b);
      case StatView.max:
        return widget.stats.map((s) => s.calculateMaxStat()).reduce((a, b) => a > b ? a : b);
    }
  }

  String _getDescription() {
    switch (_selectedView) {
      case StatView.base:
        return 'Base stats range from values of 1 to 255. They are the prime representation of the potential a Pokémon species has in battle';
      case StatView.min:
        return 'Minimum values are based on a hindering nature, 0 EVs, 0 IVs';
      case StatView.max:
        return 'Maximum values are based on a beneficial nature, 252 EVs, 31 IVs';
    }
  }

  Widget _buildToggleButton(StatView view, String label) {
    final bool isSelected = _selectedView == view;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedView = view;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? _getPrimaryTypeColor() : Colors.grey[200],
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppConstants.fontSizeRegular,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  String _getTitle() {
    switch (_selectedView) {
      case StatView.base:
        return 'Base Stats';
      case StatView.min:
        return 'Min Stats';
      case StatView.max:
        return 'Max Stats';
    }
  }

  @override
  Widget build(BuildContext context) {
    final int maxValue = _getMaxValue();

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _getPrimaryTypeColor().withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _getPrimaryTypeColor(),
                width: 1.5,
              ),
            ),
            child: Text(
              _getTitle(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _getPrimaryTypeColor(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildToggleButton(StatView.base, 'Base'),
              const SizedBox(width: 8),
              _buildToggleButton(StatView.min, 'Min'),
              const SizedBox(width: 8),
              _buildToggleButton(StatView.max, 'Max'),
            ],
          ),
          const SizedBox(height: AppConstants.mediumPadding),
          ...widget.stats.map(
            (stat) => StatBar(
              name: _formatStatName(stat.name),
              value: _getStatValue(stat),
              color: _getPrimaryTypeColor(),
              maxValue: maxValue,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Total:',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeRegular,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${_getTotalStats()}',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeRegular,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.mediumPadding),
          Text(
            _getDescription(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppConstants.fontSizeSmall,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
