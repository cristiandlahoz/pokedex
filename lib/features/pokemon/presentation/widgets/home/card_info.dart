import 'package:flutter/material.dart';
import '../../../../../core/utils/responsive_utils.dart';
import '../../constants/badge.dart';
import '../../../domain/entities/pokemon.dart';
import '../shared/type_badge.dart';

class CardInfo extends StatelessWidget {
  final Pokemon pokemon;

  const CardInfo({
    super.key,
    required this.pokemon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPokemonName(context),
        SizedBox(height: ResponsiveUtils.getSpacingSmall(context)),
        _buildTypeBadges(),
      ],
    );
  }

  Widget _buildPokemonName(BuildContext context) {
    return Text(
      pokemon.displayName,
      style: TextStyle(
        fontSize: ResponsiveUtils.getFontSizeMedium(context),
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTypeBadges() {
    return Row(
      children: pokemon.types
          .map((type) => Padding(
                padding: const EdgeInsets.only(
                  right: TypeBadgeConstants.spacing,
                ),
                child: TypeBadge(type: type),
              ))
          .toList(),
    );
  }
}
