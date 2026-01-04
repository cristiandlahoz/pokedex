import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../domain/entities/pokemon_move.dart';
import '../../../domain/entities/pokemon_types.dart';
import '../../utils/type_colors.dart';
import '../../utils/type_icons.dart';

class TCGCardAttack extends StatelessWidget {
  final PokemonMove? attack;
  final PokemonTypes type;
  final double scale;

  const TCGCardAttack({
    super.key,
    this.attack,
    required this.type,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    if (attack == null) return const SizedBox.shrink();

    final moveType = attack!.type != null
        ? PokemonTypeExtension.fromString(attack!.type!)
        : type;

    return Padding(
      padding: EdgeInsets.fromLTRB(12 * scale, 8 * scale, 12 * scale, 5 * scale),
      child: Row(
        children: [
          Container(
            width: 26 * scale,
            height: 26 * scale,
            padding: EdgeInsets.all(5 * scale),
            decoration: BoxDecoration(
              color: TypeColors.getTypeColor(moveType),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.2),
                width: 1 * scale,
              ),
            ),
            child: SvgPicture.asset(
              TypeIcons.getIconPath(moveType),
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
          SizedBox(width: 12 * scale),
          Expanded(
            child: Text(
              attack!.name,
              style: TextStyle(
                fontSize: 18 * scale,
                fontWeight: FontWeight.w900,
                color: Colors.black,
                letterSpacing: -0.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (attack!.power != null)
            Text(
              '${attack!.power}',
              style: TextStyle(
                fontSize: 24 * scale,
                fontWeight: FontWeight.w900,
                color: Colors.black,
                letterSpacing: -0.3,
              ),
            ),
        ],
      ),
    );
  }
}
