// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evolution_species_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EvolutionSpeciesHiveModelAdapter
    extends TypeAdapter<EvolutionSpeciesHiveModel> {
  @override
  final int typeId = 7;

  @override
  EvolutionSpeciesHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EvolutionSpeciesHiveModel(
      speciesId: fields[0] as int,
      speciesName: fields[1] as String,
      typeIndices: (fields[6] as List).cast<int>(),
      evolvesFromSpeciesId: fields[2] as int?,
      pokemonId: fields[3] as int?,
      pokemonName: fields[4] as String?,
      imageUrl: fields[5] as String?,
      requirements: (fields[7] as List).cast<EvolutionRequirementHiveModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, EvolutionSpeciesHiveModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.speciesId)
      ..writeByte(1)
      ..write(obj.speciesName)
      ..writeByte(2)
      ..write(obj.evolvesFromSpeciesId)
      ..writeByte(3)
      ..write(obj.pokemonId)
      ..writeByte(4)
      ..write(obj.pokemonName)
      ..writeByte(5)
      ..write(obj.imageUrl)
      ..writeByte(6)
      ..write(obj.typeIndices)
      ..writeByte(7)
      ..write(obj.requirements);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EvolutionSpeciesHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
