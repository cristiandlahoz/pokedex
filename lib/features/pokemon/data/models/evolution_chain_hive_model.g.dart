// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evolution_chain_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EvolutionChainHiveModelAdapter
    extends TypeAdapter<EvolutionChainHiveModel> {
  @override
  final int typeId = 6;

  @override
  EvolutionChainHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EvolutionChainHiveModel(
      chainId: fields[0] as int,
      species: (fields[1] as List).cast<EvolutionSpeciesHiveModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, EvolutionChainHiveModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.chainId)
      ..writeByte(1)
      ..write(obj.species);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EvolutionChainHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
