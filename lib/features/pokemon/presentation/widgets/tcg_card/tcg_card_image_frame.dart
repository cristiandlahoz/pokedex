import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TCGCardImageFrame extends StatelessWidget {
  final String imageUrl;
  final String pokedexNumber;
  final String genus;
  final String height;
  final String weight;
  final double scale;

  const TCGCardImageFrame({
    super.key,
    required this.imageUrl,
    required this.pokedexNumber,
    required this.genus,
    required this.height,
    required this.weight,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12 * scale),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8 * scale),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.3),
          width: 2 * scale,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 2 * scale,
            offset: Offset(0, 1 * scale),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 100 * scale,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(6 * scale),
              ),
            ),
            child: Center(
              child: imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      height: 90 * scale,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => SizedBox(
                        width: 40 * scale,
                        height: 40 * scale,
                        child: CircularProgressIndicator(
                          strokeWidth: 3 * scale,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.catching_pokemon,
                        size: 50 * scale,
                        color: Colors.grey,
                      ),
                    )
                  : Icon(
                      Icons.catching_pokemon,
                      size: 50 * scale,
                      color: Colors.grey,
                    ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10 * scale,
              vertical: 4 * scale,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.grey.shade300,
                  Colors.grey.shade200,
                  Colors.grey.shade300,
                ],
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(6 * scale),
              ),
            ),
            child: Text(
              '$pokedexNumber  $genus.  $height  $weight',
              style: TextStyle(
                fontSize: 11 * scale,
                color: Colors.black.withValues(alpha: 0.7),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.1,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
