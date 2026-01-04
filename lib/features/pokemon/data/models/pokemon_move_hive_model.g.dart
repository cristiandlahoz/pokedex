// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon_move_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PokemonMoveHiveModelAdapter extends TypeAdapter<PokemonMoveHiveModel> {
  @override
  final int typeId = 4;

  @override
  PokemonMoveHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PokemonMoveHiveModel(
      name: fields[0] as String,
      type: fields[1] as String?,
      power: fields[2] as int?,
      accuracy: fields[3] as int?,
      pp: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, PokemonMoveHiveModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.power)
      ..writeByte(3)
      ..write(obj.accuracy)
      ..writeByte(4)
      ..write(obj.pp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PokemonMoveHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
