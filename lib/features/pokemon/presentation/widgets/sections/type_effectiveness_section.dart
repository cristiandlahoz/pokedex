import 'package:flutter/material.dart';
import '../../../domain/entities/pokemon_details.dart';
import '../../../domain/entities/type_defense_info.dart';
import '../../utils/pokemon_type_helper.dart';
import '../shared/section_container.dart';
import '../shared/section_title_badge.dart';
import '../shared/category_header.dart';
import '../shared/type_effectiveness_badge.dart';

class TypeEffectivenessSection extends StatelessWidget {
  final PokemonDetails pokemon;

  const TypeEffectivenessSection({
    super.key,
    required this.pokemon,
  });

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

    final primaryTypeColor = PokemonTypeHelper.getPrimaryTypeColorFromDetails(pokemon);

    return SectionContainer(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SectionTitleBadge(
            title: 'Type Defenses',
            color: primaryTypeColor,
          ),
          const SizedBox(height: 16),
          if (weaknesses.isNotEmpty) ...[
            CategoryHeader(title: 'Weak to', color: Colors.red.shade700),
            const SizedBox(height: 8),
            _buildTypeList(weaknesses, showMultiplier: true),
            const SizedBox(height: 16),
          ],
          if (resistances.isNotEmpty) ...[
            CategoryHeader(title: 'Resistant to', color: Colors.green.shade700),
            const SizedBox(height: 8),
            _buildTypeList(resistances, showMultiplier: true),
            const SizedBox(height: 16),
          ],
          if (veryResistant.isNotEmpty) ...[
            CategoryHeader(title: 'Very Resistant to', color: Colors.green.shade900),
            const SizedBox(height: 8),
            _buildTypeList(veryResistant, showMultiplier: true),
            const SizedBox(height: 16),
          ],
          if (immunities.isNotEmpty) ...[
            CategoryHeader(title: 'Immune to', color: Colors.purple.shade700),
            const SizedBox(height: 8),
            _buildTypeList(immunities),
          ],
        ],
      ),
    );
  }

  Widget _buildTypeDamageCard(BuildContext context) {
    final offensiveData = _calculateOffensiveEffectiveness();
    final primaryTypeColor = PokemonTypeHelper.getPrimaryTypeColorFromDetails(pokemon);

    return SectionContainer(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SectionTitleBadge(
            title: 'Type Damage',
            color: primaryTypeColor,
          ),
          const SizedBox(height: 16),
          if (offensiveData['superEffective']!.isNotEmpty) ...[
            CategoryHeader(title: 'Super effective against', color: Colors.blue.shade700),
            const SizedBox(height: 8),
            _buildTypeList(offensiveData['superEffective']!, showMultiplier: true),
            const SizedBox(height: 16),
          ],
          if (offensiveData['notVeryEffective']!.isNotEmpty) ...[
            CategoryHeader(title: 'Not very effective against', color: Colors.orange.shade700),
            const SizedBox(height: 8),
            _buildTypeList(offensiveData['notVeryEffective']!, showMultiplier: true),
            const SizedBox(height: 16),
          ],
          if (offensiveData['noEffect']!.isNotEmpty) ...[
            CategoryHeader(title: 'No effect against', color: Colors.grey.shade700),
            const SizedBox(height: 8),
            _buildTypeList(offensiveData['noEffect']!),
          ],
        ],
      ),
    );
  }

  Map<String, List<TypeDefenseInfo>> _calculateOffensiveEffectiveness() {
    final superEffective = pokemon.typeOffenses
        .where((o) => o.damageMultiplier >= 2.0)
        .toList()
      ..sort((a, b) => b.damageMultiplier.compareTo(a.damageMultiplier));

    final notVeryEffective = pokemon.typeOffenses
        .where((o) => o.damageMultiplier > 0.0 && o.damageMultiplier <= 0.5)
        .toList()
      ..sort((a, b) => a.damageMultiplier.compareTo(b.damageMultiplier));

    final noEffect = pokemon.typeOffenses
        .where((o) => o.damageMultiplier == 0.0)
        .toList();

    return {
      'superEffective': superEffective,
      'notVeryEffective': notVeryEffective,
      'noEffect': noEffect,
    };
  }


  Widget _buildTypeList(List<TypeDefenseInfo> types, {bool showMultiplier = false}) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: types.map((typeDefense) {
        return TypeEffectivenessBadge(
          type: typeDefense.type,
          multiplier: showMultiplier ? typeDefense.damageMultiplier : null,
        );
      }).toList(),
    );
  }
}
