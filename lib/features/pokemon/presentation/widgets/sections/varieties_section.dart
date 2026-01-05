import 'package:flutter/material.dart';

import '../../../../../core/constants/app.dart';
import '../../../domain/entities/pokemon_details.dart';
import '../../../domain/entities/pokemon_variety.dart';
import '../../constants/evolution.dart';
import '../../utils/type_helper.dart';
import '../varieties/varieties_list_widget.dart';

class VarietiesSection extends StatelessWidget {
  final String title;
  final PokemonDetails pokemon;
  final List<PokemonVariety> varieties;

  const VarietiesSection({
    super.key,
    required this.title,
    required this.pokemon,
    required this.varieties,
  });

  @override
  Widget build(BuildContext context) {
    if (varieties.isEmpty) {
      return const SizedBox.shrink();
    }

    final typeColor = TypeHelper.getPrimaryTypeColor(pokemon);

    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PillSectionTitle(title: title, color: typeColor),
          const SizedBox(height: EvolutionConstants.verticalSpacing),
          VarietiesListWidget(
            varieties: varieties,
            currentPokemonId: pokemon.id,
          ),
        ],
      ),
    );
  }
}

class _PillSectionTitle extends StatelessWidget {
  final String title;
  final Color color;

  const _PillSectionTitle({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: EvolutionConstants.pillHorizontalPadding,
          vertical: EvolutionConstants.pillVerticalPadding,
        ),
        decoration: BoxDecoration(
          color: color.withValues(
            alpha: EvolutionConstants.pillBackgroundOpacity,
          ),
          borderRadius: BorderRadius.circular(
            EvolutionConstants.pillBorderRadius,
          ),
          border: Border.all(
            color: color.withValues(
              alpha: EvolutionConstants.pillBorderOpacity,
            ),
            width: EvolutionConstants.pillBorderWidth,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: EvolutionConstants.pillTextSize,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ),
    );
  }
}
