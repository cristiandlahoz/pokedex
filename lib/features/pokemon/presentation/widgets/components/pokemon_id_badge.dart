import 'package:flutter/material.dart';
import '../../../../../core/constants/ui_constants.dart';
import '../../../../../core/utils/responsive_utils.dart';

class PokemonIdBadge extends StatelessWidget {
  final int pokemonId;
  final bool isLarge;

  const PokemonIdBadge({
    super.key,
    required this.pokemonId,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatId(pokemonId),
      style: TextStyle(
        fontSize: isLarge
            ? ResponsiveUtils.getFontSizeExtraLarge(context)
            : ResponsiveUtils.getFontSizeSmall(context),
        fontWeight: FontWeight.bold,
        color: Colors.black.withValues(
          alpha: isLarge
              ? PokemonIdBadgeConstants.opacityLarge
              : PokemonIdBadgeConstants.opacityNormal,
        ),
      ),
    );
  }

  String _formatId(int id) {
    return '#${id.toString().padLeft(PokemonIdBadgeConstants.idPadLength, '0')}';
  }
}
