import 'package:equatable/equatable.dart';
import 'pokemon_types.dart';

class Pokemon extends Equatable {
  final int id;
  final String name;
  final String? imageUrl;
  final int? height;
  final int? weight;
  final List<PokemonTypes> types;

  const Pokemon({
    required this.id,
    required this.name,
    required this.types,
    this.imageUrl,
    this.height,
    this.weight,
  });

  String get displayName => name[0].toUpperCase() + name.substring(1);

  @override
  List<Object?> get props => [id, name, imageUrl, height, weight, types];
}
