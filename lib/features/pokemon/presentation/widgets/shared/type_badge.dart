import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../constants/badge.dart';
import '../../utils/type_colors.dart';
import '../../utils/type_icons.dart';
import '../../../../../core/utils/responsive_utils.dart';
import '../../../domain/entities/pokemon_types.dart';

class TypeBadge extends StatelessWidget {
  final PokemonTypes type;

  const TypeBadge({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final badgeSize = ResponsiveUtils.getTypeBadgeSize(context);

    return Container(
      width: badgeSize,
      height: badgeSize,
      padding: const EdgeInsets.all(TypeBadgeConstants.iconPadding),
      decoration: BoxDecoration(
        color: TypeColors.getColorForType(type),
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(
        TypeIcons.getIconPath(type),
      ),
    );
  }
}
