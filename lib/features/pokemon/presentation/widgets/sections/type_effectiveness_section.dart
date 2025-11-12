import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../domain/entities/pokemon_details.dart';
import '../../../domain/entities/pokemon_types.dart';
import '../../../domain/entities/type_defense_info.dart';
import '../../utils/pokemon_type_colors.dart';
import '../../utils/pokemon_type_icons.dart';

class TypeEffectivenessSection extends StatelessWidget {
  final PokemonDetails pokemon;

  const TypeEffectivenessSection({
    super.key,
    required this.pokemon,
  });

  Color _getPrimaryTypeColor() {
    final primaryType = pokemon.types.isNotEmpty
        ? pokemon.types.first.name
        : 'normal';
    return PokemonTypeColors.getColor(primaryType);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTypeDefensesCard(context),
        const SizedBox(height: 16),
        _buildTypeDamageCard(context),
      ],
    );
  }

  Widget _buildTypeDefensesCard(BuildContext context) {
    final weaknesses = pokemon.typeDefenses
        .where((d) => d.damageMultiplier >= 2.0)
        .toList()
      ..sort((a, b) => b.damageMultiplier.compareTo(a.damageMultiplier));

    final resistances = pokemon.typeDefenses
        .where((d) => d.damageMultiplier > 0.5 && d.damageMultiplier < 1.0)
        .toList()
      ..sort((a, b) => a.damageMultiplier.compareTo(b.damageMultiplier));

    final veryResistant = pokemon.typeDefenses
        .where((d) => d.damageMultiplier > 0.0 && d.damageMultiplier < 0.5)
        .toList()
      ..sort((a, b) => a.damageMultiplier.compareTo(b.damageMultiplier));

    final immunities = pokemon.typeDefenses
        .where((d) => d.damageMultiplier == 0)
        .toList();

    final primaryTypeColor = _getPrimaryTypeColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: primaryTypeColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: primaryTypeColor,
                width: 1.5,
              ),
            ),
            child: Text(
              'Type Defenses',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: primaryTypeColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (weaknesses.isNotEmpty) ...[
            _buildCategoryHeader(context, 'Weak to', Colors.red.shade700),
            const SizedBox(height: 8),
            _buildTypeList(weaknesses, showMultiplier: true),
            const SizedBox(height: 16),
          ],
          if (resistances.isNotEmpty) ...[
            _buildCategoryHeader(context, 'Resistant to', Colors.green.shade700),
            const SizedBox(height: 8),
            _buildTypeList(resistances, showMultiplier: true),
            const SizedBox(height: 16),
          ],
          if (veryResistant.isNotEmpty) ...[
            _buildCategoryHeader(context, 'Very Resistant to', Colors.green.shade900),
            const SizedBox(height: 8),
            _buildTypeList(veryResistant, showMultiplier: true),
            const SizedBox(height: 16),
          ],
          if (immunities.isNotEmpty) ...[
            _buildCategoryHeader(context, 'Immune to', Colors.purple.shade700),
            const SizedBox(height: 8),
            _buildTypeList(immunities),
          ],
        ],
      ),
    );
  }

  Widget _buildTypeDamageCard(BuildContext context) {
    final offensiveData = _calculateOffensiveEffectiveness();
    final primaryTypeColor = _getPrimaryTypeColor();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: primaryTypeColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: primaryTypeColor,
                width: 1.5,
              ),
            ),
            child: Text(
              'Type Damage',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: primaryTypeColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (offensiveData['superEffective']!.isNotEmpty) ...[
            _buildCategoryHeader(context, 'Super effective against', Colors.blue.shade700),
            const SizedBox(height: 8),
            _buildTypeList(offensiveData['superEffective']!, showMultiplier: true),
            const SizedBox(height: 16),
          ],
          if (offensiveData['notVeryEffective']!.isNotEmpty) ...[
            _buildCategoryHeader(context, 'Not very effective against', Colors.orange.shade700),
            const SizedBox(height: 8),
            _buildTypeList(offensiveData['notVeryEffective']!, showMultiplier: true),
            const SizedBox(height: 16),
          ],
          if (offensiveData['noEffect']!.isNotEmpty) ...[
            _buildCategoryHeader(context, 'No effect against', Colors.grey.shade700),
            const SizedBox(height: 8),
            _buildTypeList(offensiveData['noEffect']!),
          ],
        ],
      ),
    );
  }

  Map<String, List<TypeDefenseInfo>> _calculateOffensiveEffectiveness() {
    final Map<PokemonTypes, double> damageMultipliers = {};

    for (final attackingType in pokemon.types) {
      final effectiveness = _getTypeEffectiveness(attackingType);
      
      for (final entry in effectiveness.entries) {
        damageMultipliers[entry.key] = 
            (damageMultipliers[entry.key] ?? 1.0) * entry.value;
      }
    }

    final superEffective = <TypeDefenseInfo>[];
    final notVeryEffective = <TypeDefenseInfo>[];
    final noEffect = <TypeDefenseInfo>[];

    for (final entry in damageMultipliers.entries) {
      if (entry.value == 0) {
        noEffect.add(TypeDefenseInfo(type: entry.key, damageMultiplier: entry.value));
      } else if (entry.value >= 2.0) {
        superEffective.add(TypeDefenseInfo(type: entry.key, damageMultiplier: entry.value));
      } else if (entry.value <= 0.5) {
        notVeryEffective.add(TypeDefenseInfo(type: entry.key, damageMultiplier: entry.value));
      }
    }

    superEffective.sort((a, b) => b.damageMultiplier.compareTo(a.damageMultiplier));
    notVeryEffective.sort((a, b) => a.damageMultiplier.compareTo(b.damageMultiplier));

    return {
      'superEffective': superEffective,
      'notVeryEffective': notVeryEffective,
      'noEffect': noEffect,
    };
  }

  Map<PokemonTypes, double> _getTypeEffectiveness(PokemonTypes attackingType) {
    final Map<PokemonTypes, double> effectiveness = {};
    
    for (final type in PokemonTypes.values) {
      if (type == PokemonTypes.unknown || 
          type == PokemonTypes.monster || 
          type == PokemonTypes.shadow) {
        continue;
      }
      effectiveness[type] = 1.0;
    }

    switch (attackingType) {
      case PokemonTypes.normal:
        effectiveness[PokemonTypes.rock] = 0.5;
        effectiveness[PokemonTypes.steel] = 0.5;
        effectiveness[PokemonTypes.ghost] = 0.0;
        break;
      case PokemonTypes.fire:
        effectiveness[PokemonTypes.grass] = 2.0;
        effectiveness[PokemonTypes.ice] = 2.0;
        effectiveness[PokemonTypes.bug] = 2.0;
        effectiveness[PokemonTypes.steel] = 2.0;
        effectiveness[PokemonTypes.fire] = 0.5;
        effectiveness[PokemonTypes.water] = 0.5;
        effectiveness[PokemonTypes.rock] = 0.5;
        effectiveness[PokemonTypes.dragon] = 0.5;
        break;
      case PokemonTypes.water:
        effectiveness[PokemonTypes.fire] = 2.0;
        effectiveness[PokemonTypes.ground] = 2.0;
        effectiveness[PokemonTypes.rock] = 2.0;
        effectiveness[PokemonTypes.water] = 0.5;
        effectiveness[PokemonTypes.grass] = 0.5;
        effectiveness[PokemonTypes.dragon] = 0.5;
        break;
      case PokemonTypes.electric:
        effectiveness[PokemonTypes.water] = 2.0;
        effectiveness[PokemonTypes.flying] = 2.0;
        effectiveness[PokemonTypes.electric] = 0.5;
        effectiveness[PokemonTypes.grass] = 0.5;
        effectiveness[PokemonTypes.dragon] = 0.5;
        effectiveness[PokemonTypes.ground] = 0.0;
        break;
      case PokemonTypes.grass:
        effectiveness[PokemonTypes.water] = 2.0;
        effectiveness[PokemonTypes.ground] = 2.0;
        effectiveness[PokemonTypes.rock] = 2.0;
        effectiveness[PokemonTypes.fire] = 0.5;
        effectiveness[PokemonTypes.grass] = 0.5;
        effectiveness[PokemonTypes.poison] = 0.5;
        effectiveness[PokemonTypes.flying] = 0.5;
        effectiveness[PokemonTypes.bug] = 0.5;
        effectiveness[PokemonTypes.dragon] = 0.5;
        effectiveness[PokemonTypes.steel] = 0.5;
        break;
      case PokemonTypes.ice:
        effectiveness[PokemonTypes.grass] = 2.0;
        effectiveness[PokemonTypes.ground] = 2.0;
        effectiveness[PokemonTypes.flying] = 2.0;
        effectiveness[PokemonTypes.dragon] = 2.0;
        effectiveness[PokemonTypes.fire] = 0.5;
        effectiveness[PokemonTypes.water] = 0.5;
        effectiveness[PokemonTypes.ice] = 0.5;
        effectiveness[PokemonTypes.steel] = 0.5;
        break;
      case PokemonTypes.fighting:
        effectiveness[PokemonTypes.normal] = 2.0;
        effectiveness[PokemonTypes.ice] = 2.0;
        effectiveness[PokemonTypes.rock] = 2.0;
        effectiveness[PokemonTypes.dark] = 2.0;
        effectiveness[PokemonTypes.steel] = 2.0;
        effectiveness[PokemonTypes.poison] = 0.5;
        effectiveness[PokemonTypes.flying] = 0.5;
        effectiveness[PokemonTypes.psychic] = 0.5;
        effectiveness[PokemonTypes.bug] = 0.5;
        effectiveness[PokemonTypes.fairy] = 0.5;
        effectiveness[PokemonTypes.ghost] = 0.0;
        break;
      case PokemonTypes.poison:
        effectiveness[PokemonTypes.grass] = 2.0;
        effectiveness[PokemonTypes.fairy] = 2.0;
        effectiveness[PokemonTypes.poison] = 0.5;
        effectiveness[PokemonTypes.ground] = 0.5;
        effectiveness[PokemonTypes.rock] = 0.5;
        effectiveness[PokemonTypes.ghost] = 0.5;
        effectiveness[PokemonTypes.steel] = 0.0;
        break;
      case PokemonTypes.ground:
        effectiveness[PokemonTypes.fire] = 2.0;
        effectiveness[PokemonTypes.electric] = 2.0;
        effectiveness[PokemonTypes.poison] = 2.0;
        effectiveness[PokemonTypes.rock] = 2.0;
        effectiveness[PokemonTypes.steel] = 2.0;
        effectiveness[PokemonTypes.grass] = 0.5;
        effectiveness[PokemonTypes.bug] = 0.5;
        effectiveness[PokemonTypes.flying] = 0.0;
        break;
      case PokemonTypes.flying:
        effectiveness[PokemonTypes.grass] = 2.0;
        effectiveness[PokemonTypes.fighting] = 2.0;
        effectiveness[PokemonTypes.bug] = 2.0;
        effectiveness[PokemonTypes.electric] = 0.5;
        effectiveness[PokemonTypes.rock] = 0.5;
        effectiveness[PokemonTypes.steel] = 0.5;
        break;
      case PokemonTypes.psychic:
        effectiveness[PokemonTypes.fighting] = 2.0;
        effectiveness[PokemonTypes.poison] = 2.0;
        effectiveness[PokemonTypes.psychic] = 0.5;
        effectiveness[PokemonTypes.steel] = 0.5;
        effectiveness[PokemonTypes.dark] = 0.0;
        break;
      case PokemonTypes.bug:
        effectiveness[PokemonTypes.grass] = 2.0;
        effectiveness[PokemonTypes.psychic] = 2.0;
        effectiveness[PokemonTypes.dark] = 2.0;
        effectiveness[PokemonTypes.fire] = 0.5;
        effectiveness[PokemonTypes.fighting] = 0.5;
        effectiveness[PokemonTypes.poison] = 0.5;
        effectiveness[PokemonTypes.flying] = 0.5;
        effectiveness[PokemonTypes.ghost] = 0.5;
        effectiveness[PokemonTypes.steel] = 0.5;
        effectiveness[PokemonTypes.fairy] = 0.5;
        break;
      case PokemonTypes.rock:
        effectiveness[PokemonTypes.fire] = 2.0;
        effectiveness[PokemonTypes.ice] = 2.0;
        effectiveness[PokemonTypes.flying] = 2.0;
        effectiveness[PokemonTypes.bug] = 2.0;
        effectiveness[PokemonTypes.fighting] = 0.5;
        effectiveness[PokemonTypes.ground] = 0.5;
        effectiveness[PokemonTypes.steel] = 0.5;
        break;
      case PokemonTypes.ghost:
        effectiveness[PokemonTypes.psychic] = 2.0;
        effectiveness[PokemonTypes.ghost] = 2.0;
        effectiveness[PokemonTypes.dark] = 0.5;
        effectiveness[PokemonTypes.normal] = 0.0;
        break;
      case PokemonTypes.dragon:
        effectiveness[PokemonTypes.dragon] = 2.0;
        effectiveness[PokemonTypes.steel] = 0.5;
        effectiveness[PokemonTypes.fairy] = 0.0;
        break;
      case PokemonTypes.dark:
        effectiveness[PokemonTypes.psychic] = 2.0;
        effectiveness[PokemonTypes.ghost] = 2.0;
        effectiveness[PokemonTypes.fighting] = 0.5;
        effectiveness[PokemonTypes.dark] = 0.5;
        effectiveness[PokemonTypes.fairy] = 0.5;
        break;
      case PokemonTypes.steel:
        effectiveness[PokemonTypes.ice] = 2.0;
        effectiveness[PokemonTypes.rock] = 2.0;
        effectiveness[PokemonTypes.fairy] = 2.0;
        effectiveness[PokemonTypes.fire] = 0.5;
        effectiveness[PokemonTypes.water] = 0.5;
        effectiveness[PokemonTypes.electric] = 0.5;
        effectiveness[PokemonTypes.steel] = 0.5;
        break;
      case PokemonTypes.fairy:
        effectiveness[PokemonTypes.fighting] = 2.0;
        effectiveness[PokemonTypes.dragon] = 2.0;
        effectiveness[PokemonTypes.dark] = 2.0;
        effectiveness[PokemonTypes.fire] = 0.5;
        effectiveness[PokemonTypes.poison] = 0.5;
        effectiveness[PokemonTypes.steel] = 0.5;
        break;
      default:
        break;
    }

    return effectiveness;
  }

  Widget _buildCategoryHeader(BuildContext context, String title, Color color) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
        ),
      ],
    );
  }

  Widget _buildTypeList(List<TypeDefenseInfo> types, {bool showMultiplier = false}) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: types.map((typeDefense) {
        return _TypeEffectivenessBadge(
          type: typeDefense.type,
          multiplier: showMultiplier ? typeDefense.damageMultiplier : null,
        );
      }).toList(),
    );
  }
}

class _TypeEffectivenessBadge extends StatelessWidget {
  final PokemonTypes type;
  final double? multiplier;

  const _TypeEffectivenessBadge({
    required this.type,
    this.multiplier,
  });

  @override
  Widget build(BuildContext context) {
    final typeColor = PokemonTypeColors.getColorForType(type);
    final typeIcon = PokemonTypeIcons.getIconPath(type);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: typeColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: typeColor, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            typeIcon,
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(typeColor, BlendMode.srcIn),
          ),
          const SizedBox(width: 6),
          Text(
            type.name,
            style: TextStyle(
              color: typeColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          if (multiplier != null) ...[
            const SizedBox(width: 4),
            Text(
              '×${multiplier!.toStringAsFixed(multiplier! % 1 == 0 ? 0 : 1)}',
              style: TextStyle(
                color: typeColor.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
