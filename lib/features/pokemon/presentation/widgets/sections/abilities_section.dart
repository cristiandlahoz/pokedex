import 'package:flutter/material.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../domain/entities/pokemon_ability.dart';
import '../../../domain/entities/pokemon_details.dart';
import '../../utils/pokemon_type_colors.dart';

class _AbilitiesConstants {
  static const String explanationText = 
      'Abilities provide passive effects in battle or in the overworld. Pokémon have 1-3 abilities, though they can only have 1 at a time.';
}

class _SectionTitleBadge extends StatelessWidget {
  final Color color;

  const _SectionTitleBadge({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.mediumPadding,
        vertical: AppConstants.smallPadding / 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: AppConstants.opacityLight * 2),
        borderRadius: BorderRadius.circular(AppConstants.extraLargeBorderRadius),
        border: Border.all(
          color: color,
          width: 1.5,
        ),
      ),
      child: Text(
        'Abilities',
        style: TextStyle(
          fontSize: AppConstants.fontSizeRegular,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

class _HiddenBadge extends StatelessWidget {
  const _HiddenBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.smallPadding,
        vertical: AppConstants.smallPadding / 3,
      ),
      decoration: BoxDecoration(
        color: Colors.purple.shade100,
        borderRadius: BorderRadius.circular(AppConstants.smallPadding),
        border: Border.all(
          color: Colors.purple.shade300,
          width: 1,
        ),
      ),
      child: Text(
        'Hidden',
        style: TextStyle(
          fontSize: AppConstants.fontSizeSmall - 1,
          fontWeight: FontWeight.bold,
          color: Colors.purple.shade700,
        ),
      ),
    );
  }
}

class _AbilityCard extends StatelessWidget {
  final PokemonAbility ability;
  final Color primaryTypeColor;

  const _AbilityCard({
    required this.ability,
    required this.primaryTypeColor,
  });

  String _formatAbilityName(String name) {
    if (name.isEmpty) return '';
    return name.split('-').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.mediumPadding),
      padding: const EdgeInsets.all(AppConstants.mediumPadding),
      decoration: BoxDecoration(
        color: primaryTypeColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: Border.all(
          color: primaryTypeColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _formatAbilityName(ability.name),
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeLarge,
                    fontWeight: FontWeight.bold,
                    color: primaryTypeColor.withValues(alpha: 0.9),
                  ),
                ),
              ),
              if (ability.isHidden) ...[
                const SizedBox(width: AppConstants.smallPadding),
                const _HiddenBadge(),
              ],
              const SizedBox(width: AppConstants.smallPadding),
              Icon(
                Icons.info_outline,
                color: primaryTypeColor.withValues(alpha: 0.6),
                size: AppConstants.iconSizeSmall,
              ),
            ],
          ),
          if (ability.effect != null) ...[
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              ability.effect!,
              style: const TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                color: Colors.black54,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class AbilitiesSection extends StatelessWidget {
  final PokemonDetails pokemon;

  const AbilitiesSection({
    super.key,
    required this.pokemon,
  });

  Color get _primaryTypeColor {
    final primaryType = pokemon.types.isNotEmpty
        ? pokemon.types.first.name
        : 'normal';
    return PokemonTypeColors.getColor(primaryType);
  }

  @override
  Widget build(BuildContext context) {
    if (pokemon.abilities.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(
        top: AppConstants.mediumPadding,
        bottom: AppConstants.defaultPadding,
      ),
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _SectionTitleBadge(color: _primaryTypeColor),
          const SizedBox(height: AppConstants.mediumPadding),
          const Text(
            _AbilitiesConstants.explanationText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          ...pokemon.abilities.map((ability) => _AbilityCard(
                ability: ability,
                primaryTypeColor: _primaryTypeColor,
              )),
        ],
      ),
    );
  }
}
