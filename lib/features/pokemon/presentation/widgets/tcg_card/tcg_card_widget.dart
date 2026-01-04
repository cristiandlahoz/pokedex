import 'package:flutter/material.dart';

import '../../models/tcg_card_data.dart';
import '../../utils/type_colors.dart';
import 'tcg_card_ability.dart';
import 'tcg_card_attack.dart';
import 'tcg_card_footer.dart';
import 'tcg_card_header.dart';
import 'tcg_card_image_frame.dart';

class TCGCardWidget extends StatelessWidget {
  final TCGCardData cardData;
  final Size? fixedSize;

  const TCGCardWidget({super.key, required this.cardData, this.fixedSize});

  Color _getCardBackgroundColor() {
    return TypeColors.getTypeColor(cardData.typeForCard);
  }

  Color _getCardGradientColor() {
    final baseColor = _getCardBackgroundColor();
    return Color.lerp(baseColor, Colors.white, 0.4) ?? baseColor;
  }

  @override
  Widget build(BuildContext context) {
    final size = fixedSize ?? const Size(360, 500);
    final borderWidth = size.width * 0.025;
    final scale = size.width / 360;

    return Center(
      child: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFBCBCBC),
              const Color(0xFFD8D8D8),
              const Color(0xFFBCBCBC),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
          borderRadius: BorderRadius.circular(size.width * 0.045),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: size.width * 0.08,
              offset: Offset(0, size.width * 0.03),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(borderWidth),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size.width * 0.03),
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(size.width * 0.03),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _getCardBackgroundColor(),
                      _getCardGradientColor(),
                      _getCardBackgroundColor(),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TCGCardHeader(
                      name: cardData.name,
                      hp: cardData.hp,
                      type: cardData.typeForCard,
                      variantLabel: cardData.variantLabel,
                      scale: scale,
                    ),
                    TCGCardImageFrame(
                      imageUrl: cardData.imageUrl,
                      pokedexNumber: cardData.pokedexNumber,
                      genus: cardData.genus,
                      height: cardData.heightFormatted,
                      weight: cardData.weightFormatted,
                      scale: scale,
                    ),
                    SizedBox(height: 1 * scale),
                    TCGCardAbility(
                      abilityName: cardData.abilityName,
                      abilityEffect: cardData.abilityEffect,
                      scale: scale,
                    ),
                    Divider(
                      height: 0.5 * scale,
                      thickness: 0.3 * scale,
                      color: Colors.black38,
                    ),
                    TCGCardAttack(
                      attack: cardData.bestMove,
                      type: cardData.typeForCard,
                      scale: scale,
                    ),
                    SizedBox(height: 2 * scale),
                    Divider(
                      height: 0.5 * scale,
                      thickness: 0.3 * scale,
                      color: Colors.black38,
                    ),
                    TCGCardFooter(
                      weaknesses: cardData.weaknesses,
                      resistances: cardData.resistances,
                      retreatCost: cardData.retreatCost,
                      scale: scale,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4 * scale,
                        vertical: 1 * scale,
                      ),
                      child: Text(
                        '©2025 Pokémon',
                        style: TextStyle(
                          fontSize: 3 * scale,
                          color: Colors.black.withValues(alpha: 0.5),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
