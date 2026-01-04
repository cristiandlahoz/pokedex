// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'type_defense_info_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TypeDefenseInfoHiveModelAdapter
    extends TypeAdapter<TypeDefenseInfoHiveModel> {
  @override
  final int typeId = 5;

  @override
  TypeDefenseInfoHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TypeDefenseInfoHiveModel(
      typeIndex: fields[0] as int,
      damageMultiplier: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, TypeDefenseInfoHiveModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.typeIndex)
      ..writeByte(1)
      ..write(obj.damageMultiplier);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TypeDefenseInfoHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
