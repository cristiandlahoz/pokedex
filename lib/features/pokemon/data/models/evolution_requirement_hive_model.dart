import 'package:hive/hive.dart';

import '../../domain/entities/evolution_requirement.dart';

part 'evolution_requirement_hive_model.g.dart';

@HiveType(typeId: 8)
class EvolutionRequirementHiveModel extends HiveObject {
  @HiveField(0)
  final String trigger;

  @HiveField(1)
  final String? triggerName;

  @HiveField(2)
  final int? minLevel;

  @HiveField(3)
  final int? minHappiness;

  @HiveField(4)
  final int? minAffection;

  @HiveField(5)
  final String? timeOfDay;

  @HiveField(6)
  final String? itemName;

  @HiveField(7)
  final String? locationName;

  EvolutionRequirementHiveModel({
    required this.trigger,
    this.triggerName,
    this.minLevel,
    this.minHappiness,
    this.minAffection,
    this.timeOfDay,
    this.itemName,
    this.locationName,
  });

  factory EvolutionRequirementHiveModel.fromDomain(
    EvolutionRequirement requirement,
  ) {
    return EvolutionRequirementHiveModel(
      trigger: requirement.trigger,
      triggerName: requirement.triggerName,
      minLevel: requirement.minLevel,
      minHappiness: requirement.minHappiness,
      minAffection: requirement.minAffection,
      timeOfDay: requirement.timeOfDay,
      itemName: requirement.itemName,
      locationName: requirement.locationName,
    );
  }

  EvolutionRequirement toDomain() {
    return EvolutionRequirement(
      trigger: trigger,
      triggerName: triggerName,
      minLevel: minLevel,
      minHappiness: minHappiness,
      minAffection: minAffection,
      timeOfDay: timeOfDay,
      itemName: itemName,
      locationName: locationName,
    );
  }
}
