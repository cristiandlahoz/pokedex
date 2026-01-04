import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../domain/entities/pokemon_types.dart';
import '../../utils/type_colors.dart';
import '../../utils/type_icons.dart';

class TCGCardHeader extends StatelessWidget {
  final String name;
  final int hp;
  final PokemonTypes type;
  final String variantLabel;
  final double scale;

  const TCGCardHeader({
    super.key,
    required this.name,
    required this.hp,
    required this.type,
    required this.variantLabel,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12 * scale, 10 * scale, 12 * scale, 5 * scale),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8 * scale, vertical: 2 * scale),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(4 * scale),
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.2),
                      width: 0.5 * scale,
                    ),
                  ),
                  child: Text(
                    variantLabel.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10 * scale,
                      fontWeight: FontWeight.w900,
                      color: Colors.black.withValues(alpha: 0.7),
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                SizedBox(height: 2 * scale),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 24 * scale,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    letterSpacing: -0.3,
                    height: 1.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'HP',
                      style: TextStyle(
                        fontSize: 16 * scale,
                        fontWeight: FontWeight.w900,
                        color: Colors.red.shade600,
                        letterSpacing: 0.3,
                      ),
                    ),
                    TextSpan(
                      text: hp.toString(),
                      style: TextStyle(
                        fontSize: 26 * scale,
                        fontWeight: FontWeight.w900,
                        color: Colors.red.shade600,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8 * scale),
              Container(
                width: 32 * scale,
                height: 32 * scale,
                padding: EdgeInsets.all(6 * scale),
                decoration: BoxDecoration(
                  color: TypeColors.getTypeColor(type),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.15),
                    width: 1 * scale,
                  ),
                ),
                child: SvgPicture.asset(
                  TypeIcons.getIconPath(type),
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
