import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../domain/entities/pokemon_details.dart';
import '../../../domain/entities/pokemon_types.dart';
import '../../../domain/entities/type_defense_info.dart';
import '../../utils/pokemon_type_colors.dart';
import '../../utils/pokemon_type_icons.dart';

class TypeDefensesSection extends StatelessWidget {
  final PokemonDetails pokemon;

  const TypeDefensesSection({
    super.key,
    required this.pokemon,
  });

  @override
  Widget build(BuildContext context) {
    final weaknesses = pokemon.typeDefenses
        .where((d) => d.damageMultiplier >= 2.0)
        .toList()
      ..sort((a, b) => b.damageMultiplier.compareTo(a.damageMultiplier));

    final resistances = pokemon.typeDefenses
        .where((d) => d.damageMultiplier > 0 && d.damageMultiplier < 1.0 && d.damageMultiplier > 0.5)
        .toList()
      ..sort((a, b) => a.damageMultiplier.compareTo(b.damageMultiplier));

    final veryResistant = pokemon.typeDefenses
        .where((d) => d.damageMultiplier > 0 && d.damageMultiplier <= 0.5)
        .toList()
      ..sort((a, b) => a.damageMultiplier.compareTo(b.damageMultiplier));

    final immunities = pokemon.typeDefenses
        .where((d) => d.damageMultiplier == 0)
        .toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Type Defenses',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
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
        return _TypeDefenseBadge(
          type: typeDefense.type,
          multiplier: showMultiplier ? typeDefense.damageMultiplier : null,
        );
      }).toList(),
    );
  }
}

class _TypeDefenseBadge extends StatelessWidget {
  final PokemonTypes type;
  final double? multiplier;

  const _TypeDefenseBadge({
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
