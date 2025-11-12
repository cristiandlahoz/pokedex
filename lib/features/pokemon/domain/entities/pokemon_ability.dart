import 'package:equatable/equatable.dart';

class PokemonAbility extends Equatable {
  final int id;
  final String name;
  final bool isHidden;
  final String? effect;
  
  const PokemonAbility({
    required this.id,
    required this.name,
    required this.isHidden,
    this.effect,
  });
  
  @override
  List<Object?> get props => [id, name, isHidden, effect];
}
