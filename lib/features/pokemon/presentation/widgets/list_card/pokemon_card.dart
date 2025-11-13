import 'package:flutter/material.dart';
import '../../../../../core/constants/ui_constants.dart';
import '../../utils/pokemon_type_colors.dart';
import '../../../../../core/utils/responsive_utils.dart';
import '../../../domain/entities/pokemon.dart';
import '../../../domain/entities/pokemon_types.dart';
import 'pokemon_card_image.dart';
import 'pokemon_card_info.dart';
import 'pokemon_id_badge.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  final VoidCallback? onTap;

  const PokemonCard({super.key, required this.pokemon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final cardHeight = ResponsiveUtils.getCardHeight(context);
    final cardPadding = ResponsiveUtils.getCardPadding(context);
    final borderRadius = ResponsiveUtils.getCardBorderRadius(context);

    return Card(
      elevation: PokemonCardConstants.elevation,
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
                  PokemonCardConstants.imagePositionLeft,
                ),
                bottom: ResponsiveUtils.getHeightPercentage(
                  context,
                  PokemonCardConstants.imagePositionBottom,
                ),
                child: PokemonCardImage(
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
                child: Center(child: PokemonCardInfo(pokemon: pokemon)),
              ),
              Positioned(
                right: ResponsiveUtils.getWidthPercentage(
                  context,
                  PokemonCardConstants.idBadgePositionRight,
                ),
                top: 54,
                bottom: 0,
                child: Center(
                  child: PokemonIdBadge(pokemonId: pokemon.id, isLarge: true),
                ),
              ),
              Positioned(
                top: ResponsiveUtils.getHeightPercentage(
                  context,
                  PokemonCardConstants.heartIconTop,
                ),
                right: ResponsiveUtils.getWidthPercentage(
                  context,
                  PokemonCardConstants.heartIconRight,
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
        PokemonTypeColors.getBackgroundColorForType(primaryType),
        PokemonTypeColors.getBackgroundColorForType(
          primaryType,
          opacity: PokemonCardConstants.gradientOpacity,
        ),
        PokemonTypeColors.getBackgroundColorForType(
          secondaryType,
          opacity: PokemonCardConstants.gradientOpacity,
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
