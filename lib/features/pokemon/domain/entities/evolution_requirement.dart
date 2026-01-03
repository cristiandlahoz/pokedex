import 'package:equatable/equatable.dart';

class EvolutionRequirement extends Equatable {
  final String trigger;
  final String? triggerName;
  final int? minLevel;
  final int? minHappiness;
  final int? minAffection;
  final String? timeOfDay;
  final String? itemName;
  final String? locationName;

  const EvolutionRequirement({
    required this.trigger,
    this.triggerName,
    this.minLevel,
    this.minHappiness,
    this.minAffection,
    this.timeOfDay,
    this.itemName,
    this.locationName,
  });

  @override
  List<Object?> get props => [
    trigger,
    triggerName,
    minLevel,
    minHappiness,
    minAffection,
    timeOfDay,
    itemName,
    locationName,
  ];
}
