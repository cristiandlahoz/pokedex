import 'package:flutter/material.dart' hide Card;
import 'package:flutter/material.dart' as m;
import '../../constants/card.dart';
import '../../utils/type_colors.dart';
import '../../../../../core/utils/responsive_utils.dart';
import '../../../domain/entities/pokemon.dart';
import '../../../domain/entities/pokemon_types.dart';
import 'card_image.dart';
import 'card_info.dart';
import 'id_badge.dart';

class Card extends StatelessWidget {
  final Pokemon pokemon;
  final VoidCallback? onTap;

  const Card({super.key, required this.pokemon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cardHeight = ResponsiveUtils.getCardHeight(context);
    final cardPadding = ResponsiveUtils.getCardPadding(context);
    final borderRadius = ResponsiveUtils.getCardBorderRadius(context);

    return m.Card(
      elevation: CardConstants.elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          height: cardHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: _buildGradient(),
          ),
          child: Stack(
            children: [
              Positioned(
                left: ResponsiveUtils.getWidthPercentage(
                  context,
                  CardConstants.imagePositionLeft,
                ),
                bottom: ResponsiveUtils.getHeightPercentage(
                  context,
                  CardConstants.imagePositionBottom,
                ),
                child: CardImage(
                  imageUrl: pokemon.imageUrl ?? '',
                  pokemonId: pokemon.id,
                ),
              ),
              Positioned(
                left:
                    ResponsiveUtils.getCardImageSize(context) + cardPadding * 2,
                top: 0,
                bottom: 0,
                right:
                    ResponsiveUtils.getPokemonIdBadgeSize(context) +
                    cardPadding * 2,
                child: Center(child: CardInfo(pokemon: pokemon)),
              ),
              Positioned(
                right: ResponsiveUtils.getWidthPercentage(
                  context,
                  CardConstants.idBadgePositionRight,
                ),
                top: 54,
                bottom: 0,
                child: Center(
                  child: IdBadge(pokemonId: pokemon.id, isLarge: true),
                ),
              ),
              Positioned(
                top: ResponsiveUtils.getHeightPercentage(
                  context,
                  CardConstants.heartIconTop,
                ),
                right: ResponsiveUtils.getWidthPercentage(
                  context,
                  CardConstants.heartIconRight,
                ),
                child: Icon(
                  Icons.favorite_border,
                  color: Colors.white.withValues(alpha: 0.7),
                  size: ResponsiveUtils.getFontSizeLarge(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  LinearGradient _buildGradient() {
    final primaryType = _getPrimaryType();
    final secondaryType = _getSecondaryType();

    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        TypeColors.getBackgroundColorForType(primaryType),
        TypeColors.getBackgroundColorForType(
          primaryType,
          opacity: CardConstants.gradientOpacity,
        ),
        TypeColors.getBackgroundColorForType(
          secondaryType,
          opacity: CardConstants.gradientOpacity,
        ),
      ],
    );
  }

  PokemonTypes _getPrimaryType() {
    return pokemon.types.isNotEmpty ? pokemon.types.first : PokemonTypes.normal;
  }

  PokemonTypes _getSecondaryType() {
    return pokemon.types.length > 1 ? pokemon.types[1] : _getPrimaryType();
  }
}
