import 'package:equatable/equatable.dart';

class PokemonMove extends Equatable {
  final String name;
  final String? type;
  final int? power;
  final int? accuracy;
  final int? pp;
  final int? versionGroupId;
  final String? versionGroupName;

  const PokemonMove({
    required this.name,
    this.type,
    this.power,
    this.accuracy,
    this.pp,
    this.versionGroupId,
    this.versionGroupName,
  });

  @override
  List<Object?> get props => [name, type, power, accuracy, pp, versionGroupId, versionGroupName];
}
