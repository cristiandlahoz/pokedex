import 'package:equatable/equatable.dart';

class PokemonMove extends Equatable {
  final String name;
  final String? type;
  final int? power;
  final int? accuracy;
  final int? pp;
  final int? level;
  final String? learnMethod;
  final String? versionGroup;
  final int? machineNumber;

  const PokemonMove({
    required this.name,
    this.type,
    this.power,
    this.accuracy,
    this.pp,
    this.level,
    this.learnMethod,
    this.versionGroup,
    this.machineNumber,
  });

  @override
  List<Object?> get props => [
    name,
    type,
    power,
    accuracy,
    pp,
    level,
    learnMethod,
    versionGroup,
    machineNumber,
  ];
}
