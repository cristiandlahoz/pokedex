import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';
import '../../domain/entities/map_area.dart';

class MapOverlayPainter extends CustomPainter {
  final List<MapArea> areas;
  final Size imageSize;
  final Color highlightColor;

  MapOverlayPainter({
    required this.areas,
    required this.imageSize,
    required this.highlightColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = highlightColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = highlightColor.withValues(alpha: DesignTokens.opacityFull)
      ..style = PaintingStyle.stroke
      ..strokeWidth = DesignTokens.strokeWidthDefault;

    final scaleX = size.width / imageSize.width;
    final scaleY = size.height / imageSize.height;
    final scale = scaleX < scaleY ? scaleX : scaleY;

    final scaledWidth = imageSize.width * scale;
    final scaledHeight = imageSize.height * scale;
    final offsetX = (size.width - scaledWidth) / 2;
    final offsetY = (size.height - scaledHeight) / 2;

    canvas.save();
    canvas.translate(offsetX, offsetY);
    canvas.scale(scale);

    for (final area in areas) {
      if (!area.isValid()) continue;
      _drawArea(canvas, area, paint, borderPaint);
    }

    canvas.restore();
  }

  void _drawArea(
      Canvas canvas, MapArea area, Paint fillPaint, Paint borderPaint) {
    switch (area.shape) {
      case AreaShape.rect:
        _drawRect(canvas, area.coords, fillPaint, borderPaint);
        break;
      case AreaShape.circle:
        _drawCircle(canvas, area.coords, fillPaint, borderPaint);
        break;
      case AreaShape.polygon:
        _drawPolygon(canvas, area.coords, fillPaint, borderPaint);
        break;
    }
  }

  void _drawRect(Canvas canvas, List<double> coords, Paint fill, Paint border) {
    final rect = Rect.fromLTRB(coords[0], coords[1], coords[2], coords[3]);
    canvas.drawRect(rect, fill);
    canvas.drawRect(rect, border);
  }

  void _drawCircle(
      Canvas canvas, List<double> coords, Paint fill, Paint border) {
    final center = Offset(coords[0], coords[1]);
    final radius = coords[2];
    canvas.drawCircle(center, radius, fill);
    canvas.drawCircle(center, radius, border);
  }

  void _drawPolygon(
      Canvas canvas, List<double> coords, Paint fill, Paint border) {
    final path = Path();
    path.moveTo(coords[0], coords[1]);
    for (int i = 2; i < coords.length; i += 2) {
      path.lineTo(coords[i], coords[i + 1]);
    }
    path.close();
    canvas.drawPath(path, fill);
    canvas.drawPath(path, border);
  }

  @override
  bool shouldRepaint(MapOverlayPainter oldDelegate) {
    return oldDelegate.areas != areas ||
        oldDelegate.imageSize != imageSize ||
        oldDelegate.highlightColor != highlightColor;
  }
}
