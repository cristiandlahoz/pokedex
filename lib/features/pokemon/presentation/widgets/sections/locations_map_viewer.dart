import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/theme/tokens.dart';
import '../../../../../core/utils/responsive_utils.dart';
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
    final titleFontSize = ResponsiveUtils.getFontSizeMedium(context) * 1.2;
    final spacing = ResponsiveUtils.getSpacingMedium(context);
    final borderRadius = ResponsiveUtils.getCardBorderRadius(context);
    final horizontalMargin = ResponsiveUtils.getSpacingMedium(context);
    final shadowBlur = ResponsiveUtils.getWidthPercentage(context, 0.025);
    final shadowOffset = ResponsiveUtils.getHeightPercentage(context, 0.005);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          regionMap.region,
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        SizedBox(height: spacing),
        Container(
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: shadowBlur,
                offset: Offset(0, shadowOffset),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
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
                0.2126,
                0.7152,
                0.0722,
                0,
                0,
                0.2126,
                0.7152,
                0.0722,
                0,
                0,
                0.2126,
                0.7152,
                0.0722,
                0,
                0,
                0,
                0,
                0,
                1,
                0,
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
                  highlightColor: widget.highlightColor.withValues(
                    alpha: DesignTokens.mapHighlightOpacity,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
