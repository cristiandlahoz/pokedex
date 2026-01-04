import 'package:equatable/equatable.dart';

class PokemonVariety extends Equatable {
  final int id;
  final String name;
  final bool isDefault;
  final int order;
  final String? imageUrl;
  final String? shinyImageUrl;
  final List<String> types;

  const PokemonVariety({
    required this.id,
    required this.name,
    required this.isDefault,
    required this.order,
    this.imageUrl,
    this.shinyImageUrl,
    required this.types,
  });

  String get displayName {
    if (name.contains('-alola')) {
      return 'Alolan $_baseName';
    }
    if (name.contains('-galar')) {
      return 'Galarian $_baseName';
    }
    if (name.contains('-hisui')) {
      return 'Hisuian $_baseName';
    }
    if (name.contains('-paldea')) {
      return 'Paldean $_baseName';
    }
    if (name.contains('-mega')) {
      return 'Mega $_baseName';
    }
    if (name.contains('-gmax') || name.contains('-gigantamax')) {
      return 'Gigantamax $_baseName';
    }
    if (name.contains('-primal')) {
      return 'Primal $_baseName';
    }
    if (name.contains('-ultra')) {
      return 'Ultra $_baseName';
    }
    return _formattedName;
  }

  String get _baseName {
    return _formatName(name.split('-').first);
  }

  String get _formattedName {
    return name
        .split('-')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String _formatName(String name) {
    return name[0].toUpperCase() + name.substring(1);
  }

  @override
  List<Object?> get props => [
        id,
        name,
        isDefault,
        order,
        imageUrl,
        shinyImageUrl,
        types,
      ];
}
