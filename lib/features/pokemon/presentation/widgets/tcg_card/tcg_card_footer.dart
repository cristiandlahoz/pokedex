import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../domain/entities/type_defense_info.dart';
import '../../utils/type_colors.dart';
import '../../utils/type_icons.dart';

class TCGCardFooter extends StatelessWidget {
  final List<TypeDefenseInfo> weaknesses;
  final List<TypeDefenseInfo> resistances;
  final int retreatCost;
  final double scale;

  const TCGCardFooter({
    super.key,
    required this.weaknesses,
    required this.resistances,
    required this.retreatCost,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(12 * scale, 5 * scale, 12 * scale, 8 * scale),
      padding: EdgeInsets.symmetric(horizontal: 8 * scale, vertical: 6 * scale),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(4 * scale),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.15),
          width: 0.5 * scale,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (weaknesses.isNotEmpty)
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'weakness ',
                    style: TextStyle(
                      fontSize: 9 * scale,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0,
                    ),
                  ),
                  ...weaknesses
                      .take(1)
                      .map(
                        (w) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 14 * scale,
                              height: 14 * scale,
                              padding: EdgeInsets.all(2.5 * scale),
                              decoration: BoxDecoration(
                                color: TypeColors.getTypeColor(w.type),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  width: 0.5 * scale,
                                ),
                              ),
                              child: SvgPicture.asset(
                                TypeIcons.getIconPath(w.type),
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            Text(
                              ' ×${w.damageMultiplier.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 9 * scale,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                ],
              ),
            ),
          if (resistances.isNotEmpty)
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'resistance ',
                    style: TextStyle(
                      fontSize: 9 * scale,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0,
                    ),
                  ),
                  ...resistances
                      .take(1)
                      .map(
                        (r) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 14 * scale,
                              height: 14 * scale,
                              padding: EdgeInsets.all(2.5 * scale),
                              decoration: BoxDecoration(
                                color: TypeColors.getTypeColor(r.type),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  width: 0.5 * scale,
                                ),
                              ),
                              child: SvgPicture.asset(
                                TypeIcons.getIconPath(r.type),
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                            Text(
                              ' -${((1 - r.damageMultiplier) * 30).toInt()}',
                              style: TextStyle(
                                fontSize: 9 * scale,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0,
                              ),
                            ),
                          ],
                        ),
                      ),
                ],
              ),
            ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'retreat',
                style: TextStyle(
                  fontSize: 9 * scale,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0,
                ),
              ),
              ...List.generate(
                retreatCost.clamp(0, 3),
                (index) => Padding(
                  padding: EdgeInsets.only(left: 1.5 * scale),
                  child: Icon(
                    Icons.star,
                    size: 12 * scale,
                    color: Colors.black.withValues(alpha: 0.7),
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
