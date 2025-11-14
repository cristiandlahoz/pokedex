import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../domain/entities/pokemon_types.dart';
import '../../utils/type_colors.dart';
import '../../utils/type_icons.dart';

class TypeEffectivenessBadge extends StatelessWidget {
  final PokemonTypes type;
  final double? multiplier;
  final bool showIcon;

  const TypeEffectivenessBadge({
    super.key,
    required this.type,
    this.multiplier,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final typeColor = TypeColors.getColorForType(type);
    final typeIcon = TypeIcons.getIconPath(type);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: typeColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: typeColor, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            SvgPicture.asset(
              typeIcon,
              width: 16,
              height: 16,
              colorFilter: ColorFilter.mode(typeColor, BlendMode.srcIn),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            type.name,
            style: TextStyle(
              color: typeColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          if (multiplier != null) ...[
            const SizedBox(width: 4),
            Text(
              '×${multiplier!.toStringAsFixed(multiplier! % 1 == 0 ? 0 : 1)}',
              style: TextStyle(
                color: typeColor.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
