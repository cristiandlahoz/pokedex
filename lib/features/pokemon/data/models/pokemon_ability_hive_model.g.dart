// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon_ability_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PokemonAbilityHiveModelAdapter
    extends TypeAdapter<PokemonAbilityHiveModel> {
  @override
  final int typeId = 2;

  @override
  PokemonAbilityHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PokemonAbilityHiveModel(
      id: fields[0] as int,
      name: fields[1] as String,
      isHidden: fields[2] as bool,
      effect: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PokemonAbilityHiveModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.isHidden)
      ..writeByte(3)
      ..write(obj.effect);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PokemonAbilityHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
