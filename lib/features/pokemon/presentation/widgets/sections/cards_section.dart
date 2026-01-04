import 'package:flutter/material.dart';

import '../../../../../core/utils/responsive_utils.dart';
import '../../../domain/entities/pokemon_details.dart';
import '../../models/tcg_card_data.dart';
import '../tcg_card/tcg_card_widget.dart';
import '../../pages/tcg_card_fullscreen_viewer.dart';

class CardsSection extends StatelessWidget {
  final PokemonDetails pokemon;
  final Color typeColor;

  const CardsSection({
    super.key,
    required this.pokemon,
    required this.typeColor,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveUtils.getSpacingMedium(context);

    return Column(
      children: [
        _buildSectionButton(context, 'Cards'),
        SizedBox(height: spacing),
        _buildSingleCard(context),
        SizedBox(height: spacing),
      ],
    );
  }

  Widget _buildSectionButton(BuildContext context, String text) {
    final fontSize = ResponsiveUtils.getFontSizeMedium(context);
    final horizontalPadding = ResponsiveUtils.getWidthPercentage(context, 0.08);
    final verticalPadding = ResponsiveUtils.getHeightPercentage(context, 0.012);
    final borderRadius = ResponsiveUtils.getCardBorderRadius(context);

    return Center(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: typeColor, width: 2),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: typeColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildSingleCard(BuildContext context) {
    final cardData = TCGCardData(pokemon, variant: TCGCardVariant.basic);
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.7;
    final cardHeight = cardWidth * 1.39;

    return Center(
      child: GestureDetector(
        onTap: () => _openFullscreenViewer(context, TCGCardVariant.basic),
        child: Hero(
          tag: 'tcg_card_${pokemon.id}_single',
          child: Material(
            color: Colors.transparent,
            child: TCGCardWidget(
              cardData: cardData,
              fixedSize: Size(cardWidth, cardHeight),
            ),
          ),
        ),
      ),
    );
  }

  void _openFullscreenViewer(BuildContext context, TCGCardVariant variant) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            TCGCardFullscreenViewer(pokemon: pokemon, variant: variant),
      ),
    );
  }
}
