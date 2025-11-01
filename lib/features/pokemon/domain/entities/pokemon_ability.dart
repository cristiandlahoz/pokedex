import 'package:equatable/equatable.dart';

class PokemonAbility extends Equatable {
  final int id;
  final String name;
  final bool isHidden;
  
  const PokemonAbility({
    required this.id,
    required this.name,
    required this.isHidden,
  });
  
  @override
  List<Object?> get props => [id, name, isHidden];
}
