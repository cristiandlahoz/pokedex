import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../constants/search.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSearchChanged;

  const SearchField({
    super.key,
    required this.controller,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) => Container(
    height: SearchConstants.height,
    margin: const EdgeInsets.only(
      left: SearchConstants.marginHorizontal,
      bottom: SearchConstants.marginVertical,
      top: SearchConstants.marginVertical,
    ),
    decoration: BoxDecoration(
      color: AppColors.searchBarBackground,
      borderRadius: BorderRadius.circular(
        SearchConstants.borderRadius,
      ),
    ),
    child: TextField(
      controller: controller,
      onChanged: onSearchChanged,
      style: const TextStyle(
        fontSize: SearchConstants.fontSize,
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        hintText: 'Search for a Pokémon...',
        hintStyle: const TextStyle(
          fontSize: SearchConstants.fontSize,
          color: AppColors.hintTextColor,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(
          Icons.search,
          size: SearchConstants.iconSize,
          color: AppColors.iconColor,
        ),
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: const EdgeInsets.only(
          right: SearchConstants.horizontalPadding,
          top: 7.5,
        ),
        isDense: true,
      ),
    ),
  );
}
