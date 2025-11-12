import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_design_tokens.dart';
import '../../../domain/entities/pokemon_generation.dart';
import '../../../domain/entities/pokemon_types.dart';
import '../../../domain/value_objects/filter_criteria.dart';
import '../../models/filter_menu_config.dart';
import '../../utils/pokemon_type_icons.dart';

class PokemonFilterMenu extends StatefulWidget {
  final FilterCriteria currentFilter;
  final ValueChanged<FilterCriteria> onApply;

  const PokemonFilterMenu({
    super.key,
    required this.currentFilter,
    required this.onApply,
  });

  @override
  State<PokemonFilterMenu> createState() => _PokemonFilterMenuState();
}

class _PokemonFilterMenuState extends State<PokemonFilterMenu> {
  late Set<PokemonTypes> _selectedTypes;
  late Set<PokemonGeneration> _selectedGenerations;

  @override
  void initState() {
    super.initState();
    _selectedTypes = Set.from(widget.currentFilter.types);
    _selectedGenerations = Set.from(widget.currentFilter.generations);
  }

  int get _totalSelectedCount =>
      _selectedTypes.length + _selectedGenerations.length;

  bool get _hasChanges =>
      _selectedTypes.length != widget.currentFilter.types.length ||
      _selectedGenerations.length != widget.currentFilter.generations.length ||
      !_selectedTypes.containsAll(widget.currentFilter.types) ||
      !_selectedGenerations.containsAll(widget.currentFilter.generations);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDesignTokens.radiusL),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHandle(),
            _buildHeader(),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDesignTokens.spacingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTypeFilterSection(),
                    const SizedBox(height: AppDesignTokens.spacingXL),
                    _buildGenerationFilterSection(),
                  ],
                ),
              ),
            ),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      margin: const EdgeInsets.only(top: AppDesignTokens.spacingM),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.textSecondary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppDesignTokens.spacingL),
      child: Row(
        children: [
          Icon(Icons.filter_list, color: AppColors.primary),
          const SizedBox(width: AppDesignTokens.spacingM),
          Text(
            'Filter Pokemon',
            style: TextStyle(
              fontSize: AppDesignTokens.fontSizeXLarge,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          if (_totalSelectedCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDesignTokens.spacingS,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppDesignTokens.radiusS),
              ),
              child: Text(
                '$_totalSelectedCount',
                style: const TextStyle(
                  fontSize: AppDesignTokens.fontSizeSmall,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTypeFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Type',
              style: TextStyle(
                fontSize: AppDesignTokens.fontSizeMedium,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            if (_selectedTypes.isNotEmpty)
              TextButton(
                onPressed: () => setState(() => _selectedTypes.clear()),
                child: Text(
                  'Clear',
                  style: TextStyle(
                    fontSize: AppDesignTokens.fontSizeSmall,
                    color: AppColors.primary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppDesignTokens.spacingM),
        Wrap(
          spacing: AppDesignTokens.spacingS,
          runSpacing: AppDesignTokens.spacingS,
          children: TypeFilterItem.allTypes
              .map((item) => _buildTypeChip(item))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildTypeChip(TypeFilterItem item) {
    final isSelected = _selectedTypes.contains(item.type);

    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedTypes.remove(item.type);
          } else {
            _selectedTypes.add(item.type);
          }
        });
      },
      borderRadius: BorderRadius.circular(AppDesignTokens.radiusL),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDesignTokens.spacingM,
          vertical: AppDesignTokens.spacingS,
        ),
        decoration: BoxDecoration(
          color: isSelected ? item.color : item.color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusL),
          border: Border.all(
            color: isSelected ? item.color : item.color.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PokemonTypeIcons.getTypeIcon(
              item.type,
              size: AppDesignTokens.iconSizeSmall,
              color: isSelected ? Colors.white : item.color,
            ),
            const SizedBox(width: AppDesignTokens.spacingS),
            Text(
              item.label,
              style: TextStyle(
                fontSize: AppDesignTokens.fontSizeSmall,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : item.color,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: AppDesignTokens.spacingXS),
              const Icon(Icons.check, size: 16, color: Colors.white),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGenerationFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Generation',
              style: TextStyle(
                fontSize: AppDesignTokens.fontSizeMedium,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            if (_selectedGenerations.isNotEmpty)
              TextButton(
                onPressed: () => setState(() => _selectedGenerations.clear()),
                child: Text(
                  'Clear',
                  style: TextStyle(
                    fontSize: AppDesignTokens.fontSizeSmall,
                    color: AppColors.primary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppDesignTokens.spacingM),
        ...GenerationFilterItem.allGenerations.map(
          (item) => _buildGenerationTile(item),
        ),
      ],
    );
  }

  Widget _buildGenerationTile(GenerationFilterItem item) {
    final isSelected = _selectedGenerations.contains(item.generation);

    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedGenerations.remove(item.generation);
          } else {
            _selectedGenerations.add(item.generation);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.all(AppDesignTokens.spacingM),
        margin: const EdgeInsets.only(bottom: AppDesignTokens.spacingS),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusM),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.cardBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDesignTokens.spacingS,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textSecondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDesignTokens.radiusS),
              ),
              child: Text(
                item.label,
                style: TextStyle(
                  fontSize: AppDesignTokens.fontSizeSmall,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: AppDesignTokens.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.region,
                    style: TextStyle(
                      fontSize: AppDesignTokens.fontSizeMedium,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.range,
                    style: TextStyle(
                      fontSize: AppDesignTokens.fontSizeSmall,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: AppDesignTokens.iconSizeMedium,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Container(
      padding: const EdgeInsets.all(AppDesignTokens.spacingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.cardBorder, width: 1)),
      ),
      child: Row(
        children: [
          if (_totalSelectedCount > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _handleClearAll,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDesignTokens.spacingM,
                  ),
                  side: BorderSide(color: AppColors.cardBorder),
                ),
                child: Text(
                  'Clear All',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ),
          if (_totalSelectedCount > 0)
            const SizedBox(width: AppDesignTokens.spacingM),
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: AppDesignTokens.spacingM,
                ),
                side: BorderSide(color: AppColors.cardBorder),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ),
          const SizedBox(width: AppDesignTokens.spacingM),
          Expanded(
            child: ElevatedButton(
              onPressed: _hasChanges ? _handleApply : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: AppDesignTokens.spacingM,
                ),
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.textSecondary.withValues(
                  alpha: 0.3,
                ),
              ),
              child: const Text('Apply', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  void _handleApply() {
    final newFilter = FilterCriteria(
      types: _selectedTypes.toList(),
      generations: _selectedGenerations.toList(),
    );
    widget.onApply(newFilter);
  }

  void _handleClearAll() {
    setState(() {
      _selectedTypes.clear();
      _selectedGenerations.clear();
    });
  }
}
