import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../core/utils/responsive_utils.dart';
import '../../constants/card.dart';

class CardImage extends StatelessWidget {
  final String imageUrl;
  final int pokemonId;

  const CardImage({
    super.key,
    required this.imageUrl,
    required this.pokemonId,
  });

  @override
  Widget build(BuildContext context) {
    final imageSize = ResponsiveUtils.getCardImageSize(context);

    return Hero(
      tag: 'pokemon_$pokemonId',
      transitionOnUserGestures: true,
      child: SizedBox(
        width: imageSize,
        height: imageSize,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.contain,
          placeholder: _buildLoadingState,
          errorWidget: _buildErrorWidget,
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context, String url) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorWidget(
    BuildContext context,
    String url,
    dynamic error,
  ) {
    return const Center(
      child: Icon(
        Icons.error_outline,
        size: CardConstants.errorIconSize,
        color: Colors.red,
      ),
    );
  }
}
