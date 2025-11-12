import 'package:flutter/material.dart';
import '../../../../../core/constants/ui_constants.dart';
import '../../../../../core/theme/app_colors.dart';

class PokemonSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSearchChanged;

  const PokemonSearchField({
    super.key,
    required this.controller,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) => Container(
    height: PokemonSearchBarConstants.height,
    margin: const EdgeInsets.only(
      left: PokemonSearchBarConstants.marginHorizontal,
      bottom: PokemonSearchBarConstants.marginVertical,
      top: PokemonSearchBarConstants.marginVertical,
    ),
    decoration: BoxDecoration(
      color: AppColors.searchBarBackground,
      borderRadius: BorderRadius.circular(
        PokemonSearchBarConstants.borderRadius,
      ),
    ),
    child: TextField(
      controller: controller,
      onChanged: onSearchChanged,
      style: const TextStyle(
        fontSize: PokemonSearchBarConstants.fontSize,
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: 'Search for a Pokémon...',
        hintStyle: const TextStyle(
          fontSize: PokemonSearchBarConstants.fontSize,
          color: AppColors.hintTextColor,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(
          Icons.search,
          size: PokemonSearchBarConstants.iconSize,
          color: AppColors.iconColor,
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: const EdgeInsets.only(
          right: PokemonSearchBarConstants.horizontalPadding,
          top: 7.5,
        ),
        isDense: true,
      ),
    ),
  );
}
