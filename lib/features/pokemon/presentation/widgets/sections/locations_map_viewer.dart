import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/theme/tokens.dart';
import '../../../domain/entities/region_map.dart';
import '../../utils/map_overlay_painter.dart';

class LocationsMapViewer extends StatelessWidget {
  final RegionMap regionMap;
  final Color typeColor;

  const LocationsMapViewer({
    super.key,
    required this.regionMap,
    required this.typeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            regionMap.region,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: typeColor,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: _MapWithOverlay(
                map: regionMap,
                highlightedAreas: regionMap.highlightedAreas,
                highlightColor: Colors.red,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MapWithOverlay extends StatefulWidget {
  final RegionMap map;
  final List<String> highlightedAreas;
  final Color highlightColor;

  const _MapWithOverlay({
    required this.map,
    required this.highlightedAreas,
    required this.highlightColor,
  });

  @override
  State<_MapWithOverlay> createState() => _MapWithOverlayState();
}

class _MapWithOverlayState extends State<_MapWithOverlay> {
  Size? _imageSize;

  @override
  void initState() {
    super.initState();
    _loadImageSize();
  }

  @override
  void didUpdateWidget(_MapWithOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.map.imagePath != widget.map.imagePath) {
      _loadImageSize();
    }
  }

  Future<void> _loadImageSize() async {
    final data = await rootBundle.load(widget.map.imagePath);
    final bytes = data.buffer.asUint8List();
    final image = await decodeImageFromList(bytes);
    if (mounted) {
      setState(() {
        _imageSize = Size(image.width.toDouble(), image.height.toDouble());
      });
    }
    image.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            ColorFiltered(
              colorFilter: const ColorFilter.matrix([
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0.2126, 0.7152, 0.0722, 0, 0,
                0,      0,      0,      1, 0,
              ]),
              child: Image.asset(
                widget.map.imagePath,
                fit: BoxFit.contain,
                width: constraints.maxWidth,
                height: constraints.maxHeight,
              ),
            ),
            if (_imageSize != null)
              CustomPaint(
                size: constraints.biggest,
                painter: MapOverlayPainter(
                  areas: widget.map.getAreasByNames(widget.highlightedAreas),
                  imageSize: _imageSize!,
                  highlightColor: widget.highlightColor.withValues(alpha: DesignTokens.mapHighlightOpacity),
                ),
              ),
          ],
        );
      },
    );
  }
}
