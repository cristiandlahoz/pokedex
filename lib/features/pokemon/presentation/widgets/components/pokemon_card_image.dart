import 'package:flutter/material.dart';
import '../../../../../core/constants/ui_constants.dart';
import '../../../../../core/utils/responsive_utils.dart';

class PokemonCardImage extends StatelessWidget {
  final String imageUrl;
  final int pokemonId;

  const PokemonCardImage({
    super.key,
    required this.imageUrl,
    required this.pokemonId,
  });

  @override
  Widget build(BuildContext context) {
    final imageSize = ResponsiveUtils.getCardImageSize(context);

    return Hero(
      tag: 'pokemon_$pokemonId',
      child: SizedBox(
        width: imageSize,
        height: imageSize,
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
          loadingBuilder: _buildLoadingState,
          errorBuilder: _buildErrorState,
        ),
      ),
    );
  }

  Widget _buildLoadingState(
    BuildContext context,
    Widget child,
    ImageChunkEvent? loadingProgress,
  ) {
    if (loadingProgress == null) return child;

    return Center(
      child: CircularProgressIndicator(
        value: _calculateLoadingProgress(loadingProgress),
      ),
    );
  }

  double? _calculateLoadingProgress(ImageChunkEvent loadingProgress) {
    final totalBytes = loadingProgress.expectedTotalBytes;
    if (totalBytes == null) return null;

    return loadingProgress.cumulativeBytesLoaded / totalBytes;
  }

  Widget _buildErrorState(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return const Center(
      child: Icon(
        Icons.error_outline,
        size: PokemonCardConstants.errorIconSize,
        color: Colors.red,
      ),
    );
  }
}
