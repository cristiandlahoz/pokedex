import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../domain/entities/pokemon_types.dart';
import '../../constants/evolution.dart';
import 'type_badge.dart';

class PokemonCardBase extends StatelessWidget {
  final String? imageUrl;
  final List<PokemonTypes> types;
  final String name;
  final VoidCallback? onTap;
  final bool showBorder;
  final Widget? extraContent;

  const PokemonCardBase({
    super.key,
    this.imageUrl,
    required this.types,
    required this.name,
    this.onTap,
    this.showBorder = false,
    this.extraContent,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: EvolutionConstants.cardWidth,
        padding: const EdgeInsets.all(EvolutionConstants.cardPadding),
        decoration: _buildDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSprite(),
            const SizedBox(height: EvolutionConstants.textSpacing),
            _buildTypeBadges(),
            const SizedBox(height: EvolutionConstants.textSpacing),
            _buildName(),
            if (extraContent != null) ...[
              const SizedBox(height: EvolutionConstants.textSpacing),
              extraContent!,
            ],
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(EvolutionConstants.cardBorderRadius),
      border: showBorder
          ? Border.all(
              color: EvolutionConstants.selectedBorderColor,
              width: EvolutionConstants.selectedBorderWidth,
            )
          : null,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(
            alpha: EvolutionConstants.cardShadowOpacity,
          ),
          blurRadius: EvolutionConstants.cardShadowBlur,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _buildSprite() {
    if (imageUrl == null) {
      return Container(
        width: EvolutionConstants.spriteSizeLarge,
        height: EvolutionConstants.spriteSizeLarge,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.question_mark, color: Colors.grey),
      );
    }

    return SizedBox(
      width: EvolutionConstants.spriteSizeLarge,
      height: EvolutionConstants.spriteSizeLarge,
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.contain,
        placeholder: (context, url) => Container(
          width: EvolutionConstants.spriteSizeLarge,
          height: EvolutionConstants.spriteSizeLarge,
          color: Colors.grey[200],
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }

  Widget _buildTypeBadges() {
    if (types.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: types.take(2).map((type) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: TypeBadge(type: type),
        );
      }).toList(),
    );
  }

  Widget _buildName() {
    return Text(
      name,
      style: const TextStyle(
        fontSize: EvolutionConstants.nameTextSize,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
