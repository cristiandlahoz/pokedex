import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/tokens.dart';
import '../../../domain/entities/pokemon_generation.dart';
import '../../../domain/entities/pokemon_types.dart';
import '../../../domain/value_objects/filters.dart';
import '../../models/filter_menu_config.dart';
import '../../utils/type_icons.dart';

class FilterMenu extends StatefulWidget {
  final Filters currentFilter;
  final ValueChanged<Filters> onApply;

  const FilterMenu({
    super.key,
    required this.currentFilter,
    required this.onApply,
  });

  @override
  State<FilterMenu> createState() => _FilterMenuState();
}

class _FilterMenuState extends State<FilterMenu> {
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
          top: Radius.circular(DesignTokens.radiusL),
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
                padding: const EdgeInsets.all(DesignTokens.spacingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTypeFilterSection(),
                    const SizedBox(height: DesignTokens.spacingXL),
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
      margin: const EdgeInsets.only(top: DesignTokens.spacingM),
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
      padding: const EdgeInsets.all(DesignTokens.spacingL),
      child: Row(
        children: [
          Icon(Icons.filter_list, color: AppColors.primary),
          const SizedBox(width: DesignTokens.spacingM),
          Text(
            'Filter Pokemon',
            style: TextStyle(
              fontSize: DesignTokens.fontSizeXLarge,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          if (_totalSelectedCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingS,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(DesignTokens.radiusS),
              ),
              child: Text(
                '$_totalSelectedCount',
                style: const TextStyle(
                  fontSize: DesignTokens.fontSizeSmall,
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
                fontSize: DesignTokens.fontSizeMedium,
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
                    fontSize: DesignTokens.fontSizeSmall,
                    color: AppColors.primary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: DesignTokens.spacingM),
        Wrap(
          spacing: DesignTokens.spacingS,
          runSpacing: DesignTokens.spacingS,
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
      borderRadius: BorderRadius.circular(DesignTokens.radiusL),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignTokens.spacingM,
          vertical: DesignTokens.spacingS,
        ),
        decoration: BoxDecoration(
          color: isSelected ? item.color : item.color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(DesignTokens.radiusL),
          border: Border.all(
            color: isSelected ? item.color : item.color.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TypeIcons.getTypeIcon(
              item.type,
              size: DesignTokens.iconSizeSmall,
              color: isSelected ? Colors.white : item.color,
            ),
            const SizedBox(width: DesignTokens.spacingS),
            Text(
              item.label,
              style: TextStyle(
                fontSize: DesignTokens.fontSizeSmall,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : item.color,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: DesignTokens.spacingXS),
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
                fontSize: DesignTokens.fontSizeMedium,
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
                    fontSize: DesignTokens.fontSizeSmall,
                    color: AppColors.primary,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: DesignTokens.spacingM),
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
        padding: const EdgeInsets.all(DesignTokens.spacingM),
        margin: const EdgeInsets.only(bottom: DesignTokens.spacingS),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.cardBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignTokens.spacingS,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textSecondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(DesignTokens.radiusS),
              ),
              child: Text(
                item.label,
                style: TextStyle(
                  fontSize: DesignTokens.fontSizeSmall,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(width: DesignTokens.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.region,
                    style: TextStyle(
                      fontSize: DesignTokens.fontSizeMedium,
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
                      fontSize: DesignTokens.fontSizeSmall,
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
                size: DesignTokens.iconSizeMedium,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Container(
      padding: const EdgeInsets.all(DesignTokens.spacingL),
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
                    vertical: DesignTokens.spacingM,
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
            const SizedBox(width: DesignTokens.spacingM),
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: DesignTokens.spacingM,
                ),
                side: BorderSide(color: AppColors.cardBorder),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ),
          const SizedBox(width: DesignTokens.spacingM),
          Expanded(
            child: ElevatedButton(
              onPressed: _hasChanges ? _handleApply : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: DesignTokens.spacingM,
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
    final newFilter = Filters(
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
