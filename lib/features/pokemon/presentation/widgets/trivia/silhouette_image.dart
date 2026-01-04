import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../constants/trivia.dart';

class SilhouetteImage extends StatelessWidget {
  final String imageUrl;
  final int level;
  final bool revealed;

  const SilhouetteImage({
    super.key,
    required this.imageUrl,
    required this.level,
    this.revealed = false,
  });

  @override
  Widget build(BuildContext context) {
    final levelConfig = TriviaConstants.levelConfigs[level];
    final opacity = levelConfig?.silhouetteOpacity ?? 1.0;
    final isPartialOpacity = opacity < 1.0;

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: TriviaConstants.silhouetteMaxHeight,
      ),
      child: revealed
          ? _buildRevealedImage()
          : _buildSilhouetteImage(isPartialOpacity),
    );
  }

  Widget _buildRevealedImage() {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.contain,
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) =>
          const Icon(Icons.catching_pokemon, size: 200, color: Colors.grey),
    );
  }

  Widget _buildSilhouetteImage(bool isPartialOpacity) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.black,
        isPartialOpacity ? BlendMode.srcATop : BlendMode.srcIn,
      ),
      child: Opacity(
        opacity: isPartialOpacity ? 0.4 : 1.0,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.contain,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) =>
              const Icon(Icons.catching_pokemon, size: 200, color: Colors.grey),
        ),
      ),
    );
  }
}
