// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PokemonHiveModelAdapter extends TypeAdapter<PokemonHiveModel> {
  @override
  final int typeId = 0;

  @override
  PokemonHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PokemonHiveModel(
      id: fields[0] as int,
      name: fields[1] as String,
      typeIds: (fields[5] as List).cast<int>(),
      addedAt: fields[6] as DateTime,
      imageUrl: fields[2] as String?,
      height: fields[3] as int?,
      weight: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, PokemonHiveModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.height)
      ..writeByte(4)
      ..write(obj.weight)
      ..writeByte(5)
      ..write(obj.typeIds)
      ..writeByte(6)
      ..write(obj.addedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PokemonHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
