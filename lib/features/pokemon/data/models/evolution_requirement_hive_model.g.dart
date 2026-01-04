// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evolution_requirement_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EvolutionRequirementHiveModelAdapter
    extends TypeAdapter<EvolutionRequirementHiveModel> {
  @override
  final int typeId = 8;

  @override
  EvolutionRequirementHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EvolutionRequirementHiveModel(
      trigger: fields[0] as String,
      triggerName: fields[1] as String?,
      minLevel: fields[2] as int?,
      minHappiness: fields[3] as int?,
      minAffection: fields[4] as int?,
      timeOfDay: fields[5] as String?,
      itemName: fields[6] as String?,
      locationName: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, EvolutionRequirementHiveModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.trigger)
      ..writeByte(1)
      ..write(obj.triggerName)
      ..writeByte(2)
      ..write(obj.minLevel)
      ..writeByte(3)
      ..write(obj.minHappiness)
      ..writeByte(4)
      ..write(obj.minAffection)
      ..writeByte(5)
      ..write(obj.timeOfDay)
      ..writeByte(6)
      ..write(obj.itemName)
      ..writeByte(7)
      ..write(obj.locationName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EvolutionRequirementHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
