import 'package:equatable/equatable.dart';

enum AreaShape {
  rect,
  circle,
  polygon;

  static AreaShape fromString(String value) {
    return switch (value.toLowerCase()) {
      'rect' || 'rectangle' => AreaShape.rect,
      'circle' => AreaShape.circle,
      'polygon' || 'poly' => AreaShape.polygon,
      _ => throw ArgumentError('Unknown shape: $value'),
    };
  }
}

class MapArea extends Equatable {
  final String name;
  final AreaShape shape;
  final List<double> coords;

  const MapArea({
    required this.name,
    required this.shape,
    required this.coords,
  });

  bool isValid() {
    switch (shape) {
      case AreaShape.rect:
        return coords.length == 4;
      case AreaShape.circle:
        return coords.length == 3;
      case AreaShape.polygon:
        return coords.length >= 6 && coords.length % 2 == 0;
    }
  }

  @override
  List<Object?> get props => [name, shape, coords];
}
