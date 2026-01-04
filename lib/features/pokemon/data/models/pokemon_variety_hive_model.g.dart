// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon_variety_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PokemonVarietyHiveModelAdapter
    extends TypeAdapter<PokemonVarietyHiveModel> {
  @override
  final int typeId = 11;

  @override
  PokemonVarietyHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PokemonVarietyHiveModel(
      id: fields[0] as int,
      name: fields[1] as String,
      isDefault: fields[2] as bool,
      order: fields[3] as int,
      imageUrl: fields[4] as String?,
      shinyImageUrl: fields[5] as String?,
      types: (fields[6] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, PokemonVarietyHiveModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.isDefault)
      ..writeByte(3)
      ..write(obj.order)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.shinyImageUrl)
      ..writeByte(6)
      ..write(obj.types);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PokemonVarietyHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
