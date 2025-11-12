import 'package:flutter/material.dart';
import '../../../../../core/constants/ui_constants.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_design_tokens.dart';
import 'pokemon_search_field.dart';

class PokemonListAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback? onSortPressed;
  final VoidCallback? onFilterPressed;

  const PokemonListAppBar({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    this.onSortPressed,
    this.onFilterPressed,
  });

  @override
  Size get preferredSize => Size.fromHeight(AppBarConstants.preferredHeight);

  @override
  Widget build(BuildContext context) => AppBar(
    backgroundColor: AppColors.surface,
    elevation: 0,
    toolbarHeight: AppBarConstants.toolbarHeight,
    title: Text(
      'Pokédex',
      style: TextStyle(
        fontSize: AppDesignTokens.fontSizeXLarge,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
        letterSpacing: -0.5,
      ),
    ),
    actions: [
      IconButton(
        icon: Icon(
          Icons.settings,
          color: AppColors.iconColor,
          size: AppDesignTokens.iconSizeLarge,
        ),
        tooltip: 'Settings',
        onPressed: () {},
      ),
    ],
    flexibleSpace: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            children: [
              Expanded(
                child: PokemonSearchField(
                  controller: searchController,
                  onSearchChanged: onSearchChanged,
                ),
              ),
              _buildActionButton(
                icon: Icons.sort,
                tooltip: 'Sort',
                onPressed: onSortPressed,
              ),
              _buildActionButton(
                icon: Icons.filter_alt_outlined,
                tooltip: 'Filter',
                onPressed: onFilterPressed,
              ),
              const SizedBox(width: AppDesignTokens.spacingL),
            ],
          ),
          const SizedBox(height: AppDesignTokens.spacingS),
        ],
      ),
    ),
  );

  Widget _buildActionButton({
    required IconData icon,
    required String tooltip,
    VoidCallback? onPressed,
  }) => SizedBox(
    width: AppBarConstants.actionButtonSize,
    height: AppBarConstants.actionButtonSize,
    child: IconButton(
      icon: Icon(
        icon,
        color: AppColors.iconColor,
        size: AppBarConstants.actionButtonIconSize,
      ),
      tooltip: tooltip,
      onPressed: onPressed ?? () {},
    ),
  );
}
