import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/ui_constants.dart';
import '../../utils/pokemon_type_colors.dart';
import '../../utils/pokemon_type_icons.dart';
import '../../../../../core/utils/responsive_utils.dart';
import '../../../domain/entities/pokemon_types.dart';

class PokemonTypeBadge extends StatelessWidget {
  final PokemonTypes type;

  const PokemonTypeBadge({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final badgeSize = ResponsiveUtils.getTypeBadgeSize(context);

    return Container(
      width: badgeSize,
      height: badgeSize,
      padding: const EdgeInsets.all(PokemonTypeBadgeConstants.iconPadding),
      decoration: BoxDecoration(
        color: PokemonTypeColors.getColorForType(type),
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(
        PokemonTypeIcons.getIconPath(type),
      ),
    );
  }
}
