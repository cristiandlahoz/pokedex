import 'package:flutter/material.dart';
import '../../../../../core/utils/responsive_utils.dart';
import '../../constants/badge.dart';

class IdBadge extends StatelessWidget {
  final int pokemonId;
  final bool isLarge;

  const IdBadge({
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
        fontFamily: 'Serif',
        fontWeight: FontWeight.bold,
        letterSpacing: 0.8,
        shadows: [
          Shadow(
            color: Colors.white70.withValues(
              alpha: BadgeConstants.shadowOpacityLarge,
            ),
            offset: const Offset(
              BadgeConstants.shadowOffsetSizeX,
              BadgeConstants.shadowOffsetSizeY,
            ),
            blurRadius: 2,
          ),
        ],
        fontStyle: FontStyle.italic,
        color: Colors.white12.withValues(
          alpha: isLarge
              ? BadgeConstants.opacityLarge
              : BadgeConstants.opacityNormal,
        ),
      ),
    );
  }

  String _formatId(int id) {
    return '#${id.toString().padLeft(BadgeConstants.idPadLength, '0')}';
  }
}
