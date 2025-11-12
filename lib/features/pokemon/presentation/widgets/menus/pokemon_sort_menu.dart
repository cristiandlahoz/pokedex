import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_design_tokens.dart';
import '../../../domain/value_objects/sort_criteria.dart';
import '../../models/sort_menu_item.dart';

class PokemonSortMenu extends StatefulWidget {
  final SortCriteria currentSort;
  final ValueChanged<SortCriteria> onApply;

  const PokemonSortMenu({
    super.key,
    required this.currentSort,
    required this.onApply,
  });

  @override
  State<PokemonSortMenu> createState() => _PokemonSortMenuState();
}

class _PokemonSortMenuState extends State<PokemonSortMenu> {
  late SortField _selectedField;
  late SortDirection _selectedDirection;

  @override
  void initState() {
    super.initState();
    _selectedField = widget.currentSort.field;
    _selectedDirection = widget.currentSort.direction;
  }

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
                    _buildSortFieldSection(),
                    const SizedBox(height: AppDesignTokens.spacingXL),
                    _buildSortDirectionSection(),
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
          Icon(Icons.sort, color: AppColors.primary),
          const SizedBox(width: AppDesignTokens.spacingM),
          Text(
            'Sort Pokemon',
            style: TextStyle(
              fontSize: AppDesignTokens.fontSizeXLarge,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortFieldSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sort by',
          style: TextStyle(
            fontSize: AppDesignTokens.fontSizeMedium,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppDesignTokens.spacingM),
        ...SortMenuItem.allOptions.map((item) => _buildSortFieldTile(item)),
      ],
    );
  }

  Widget _buildSortFieldTile(SortMenuItem item) {
    final isSelected = _selectedField == item.field;

    return InkWell(
      onTap: () => setState(() => _selectedField = item.field),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDesignTokens.spacingM,
          vertical: AppDesignTokens.spacingS,
        ),
        margin: const EdgeInsets.only(bottom: AppDesignTokens.spacingS),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusM),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              item.icon,
              color: isSelected ? AppColors.primary : AppColors.iconColor,
              size: AppDesignTokens.iconSizeMedium,
            ),
            const SizedBox(width: AppDesignTokens.spacingM),
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  fontSize: AppDesignTokens.fontSizeMedium,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color:
                      isSelected ? AppColors.primary : AppColors.textPrimary,
                ),
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

  Widget _buildSortDirectionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order',
          style: TextStyle(
            fontSize: AppDesignTokens.fontSizeMedium,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppDesignTokens.spacingM),
        Row(
          children: [
            Expanded(
              child: _buildDirectionButton(
                direction: SortDirection.ascending,
                icon: Icons.arrow_upward,
                label: 'Ascending',
              ),
            ),
            const SizedBox(width: AppDesignTokens.spacingM),
            Expanded(
              child: _buildDirectionButton(
                direction: SortDirection.descending,
                icon: Icons.arrow_downward,
                label: 'Descending',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDirectionButton({
    required SortDirection direction,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _selectedDirection == direction;

    return InkWell(
      onTap: () => setState(() => _selectedDirection = direction),
      child: Container(
        padding: const EdgeInsets.all(AppDesignTokens.spacingM),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.background,
          borderRadius: BorderRadius.circular(AppDesignTokens.radiusM),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.cardBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.iconColor,
              size: AppDesignTokens.iconSizeLarge,
            ),
            const SizedBox(height: AppDesignTokens.spacingS),
            Text(
              label,
              style: TextStyle(
                fontSize: AppDesignTokens.fontSizeSmall,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
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
        border: Border(
          top: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
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
              onPressed: _handleApply,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: AppDesignTokens.spacingM,
                ),
                backgroundColor: AppColors.primary,
              ),
              child: const Text(
                'Apply',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleApply() {
    final newSort = SortCriteria(
      field: _selectedField,
      direction: _selectedDirection,
    );
    widget.onApply(newSort);
  }
}
