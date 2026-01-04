import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/entities/pokemon_details.dart';
import '../models/tcg_card_data.dart';
import '../widgets/tcg_card/tcg_card_widget.dart';
import '../utils/type_helper.dart';

class TCGCardFullscreenViewer extends StatefulWidget {
  final PokemonDetails pokemon;
  final TCGCardVariant variant;

  const TCGCardFullscreenViewer({
    super.key,
    required this.pokemon,
    this.variant = TCGCardVariant.basic,
  });

  @override
  State<TCGCardFullscreenViewer> createState() =>
      _TCGCardFullscreenViewerState();
}

class _TCGCardFullscreenViewerState extends State<TCGCardFullscreenViewer> {
  final GlobalKey _cardKey = GlobalKey();
  bool _isSharing = false;

  @override
  Widget build(BuildContext context) {
    final cardData = TCGCardData(widget.pokemon, variant: widget.variant);
    final typeColor = TypeHelper.getPrimaryTypeColor(widget.pokemon);
    
    final screenWidth = MediaQuery.of(context).size.width;
    
    final cardWidth = (screenWidth * 0.85).clamp(280.0, 450.0);
    final cardHeight = cardWidth * 1.39;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: _showCardInfo,
          ),
        ],
      ),
      body: Stack(
        children: [
          InteractiveViewer(
            minScale: 1.0,
            maxScale: 4.0,
            child: Center(
              child: RepaintBoundary(
                key: _cardKey,
                child: Hero(
                  tag: 'tcg_card_${widget.pokemon.id}',
                  child: TCGCardWidget(
                    cardData: cardData,
                    fixedSize: Size(cardWidth, cardHeight),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 32,
            right: 32,
            child: FloatingActionButton.extended(
              onPressed: _isSharing ? null : _shareCard,
              backgroundColor: typeColor,
              icon: _isSharing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.share),
              label: Text(_isSharing ? 'Sharing...' : 'Share'),
            ),
          ),
        ],
      ),
    );
  }

  void _showCardInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('TCG Card Info'),
        content: const Text(
          'This is an authentic-style Pokémon TCG card generated with real game data.\n\n'
          'Stats include:\n'
          '• HP from base stats\n'
          '• Type-based coloring\n'
          '• Strongest move as attack\n'
          '• Primary ability\n'
          '• Type weaknesses & resistances\n'
          '• Speed-based retreat cost\n\n'
          'Tap "Share" to save or send this card!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  Future<void> _shareCard() async {
    setState(() => _isSharing = true);

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final boundary = _cardKey.currentContext!.findRenderObject()
          as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        throw Exception('Failed to generate image');
      }

      final bytes = byteData.buffer.asUint8List();

      await Share.shareXFiles(
        [
          XFile.fromData(
            bytes,
            name: '${widget.pokemon.name}_tcg_card.png',
            mimeType: 'image/png',
          ),
        ],
        text: 'Check out my ${widget.pokemon.displayName} TCG card from Pokedex!',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sharing card: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSharing = false);
      }
    }
  }
}
