import 'package:equatable/equatable.dart';
import 'pokemon_types.dart';

class TypeDefenseInfo extends Equatable {
  final PokemonTypes type;
  final double damageMultiplier;

  const TypeDefenseInfo({
    required this.type,
    required this.damageMultiplier,
  });

  @override
  List<Object?> get props => [type, damageMultiplier];
}
