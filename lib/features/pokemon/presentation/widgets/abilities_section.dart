import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/pokemon_ability.dart';
import 'info_placeholder.dart';

class AbilitiesSection extends StatelessWidget {
  final List<PokemonAbility> abilities;

  const AbilitiesSection({
    super.key,
    required this.abilities,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Abilities',
            style: TextStyle(
              fontSize: AppConstants.fontSizeTitle,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppConstants.mediumPadding),
          if (abilities.isEmpty)
            const InfoPlaceholder(message: 'No abilities data available')
          else
            ...abilities.map(_buildAbilityCard),
        ],
      ),
    );
  }

  Widget _buildAbilityCard(PokemonAbility ability) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(AppConstants.mediumPadding),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: Row(
        children: [
          Icon(
            Icons.verified,
            color: Colors.blue.shade700,
            size: AppConstants.iconSizeSmall,
          ),
          const SizedBox(width: AppConstants.smallPadding),
          Expanded(
            child: Text(
              _formatAbilityName(ability.name),
              style: TextStyle(
                fontSize: AppConstants.fontSizeLarge,
                fontWeight: FontWeight.w500,
                color: Colors.blue.shade900,
              ),
            ),
          ),
          if (ability.isHidden) _buildHiddenBadge(),
        ],
      ),
    );
  }

  Widget _buildHiddenBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.purple.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Hidden',
        style: TextStyle(
          fontSize: AppConstants.fontSizeSmall,
          fontWeight: FontWeight.bold,
          color: Colors.purple.shade700,
        ),
      ),
    );
  }

  String _formatAbilityName(String name) {
    if (name.isEmpty) return '';
    return name[0].toUpperCase() + name.substring(1).replaceAll('-', ' ');
  }
}
