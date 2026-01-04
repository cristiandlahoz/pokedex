// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon_details_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PokemonDetailsHiveModelAdapter
    extends TypeAdapter<PokemonDetailsHiveModel> {
  @override
  final int typeId = 1;

  @override
  PokemonDetailsHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PokemonDetailsHiveModel(
      id: fields[0] as int,
      name: fields[1] as String,
      typeIndices: (fields[2] as List).cast<int>(),
      imageUrl: fields[3] as String?,
      height: fields[4] as int?,
      weight: fields[5] as int?,
      genus: fields[6] as String?,
      description: fields[7] as String?,
      abilities: (fields[8] as List).cast<PokemonAbilityHiveModel>(),
      stats: (fields[9] as List).cast<PokemonStatHiveModel>(),
      moves: (fields[10] as List).cast<PokemonMoveHiveModel>(),
      baseExperience: fields[11] as int?,
      captureRate: fields[12] as int?,
      baseHappiness: fields[13] as int?,
      growthRate: fields[14] as String?,
      eggGroup: fields[15] as String?,
      genderRatio: fields[16] as int?,
      eggGroups: (fields[17] as List).cast<String>(),
      typeDefenses: (fields[18] as List).cast<TypeDefenseInfoHiveModel>(),
      typeOffenses: (fields[19] as List).cast<TypeDefenseInfoHiveModel>(),
      evolutionChain: fields[20] as EvolutionChainHiveModel?,
    );
  }

  @override
  void write(BinaryWriter writer, PokemonDetailsHiveModel obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.typeIndices)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.height)
      ..writeByte(5)
      ..write(obj.weight)
      ..writeByte(6)
      ..write(obj.genus)
      ..writeByte(7)
      ..write(obj.description)
      ..writeByte(8)
      ..write(obj.abilities)
      ..writeByte(9)
      ..write(obj.stats)
      ..writeByte(10)
      ..write(obj.moves)
      ..writeByte(11)
      ..write(obj.baseExperience)
      ..writeByte(12)
      ..write(obj.captureRate)
      ..writeByte(13)
      ..write(obj.baseHappiness)
      ..writeByte(14)
      ..write(obj.growthRate)
      ..writeByte(15)
      ..write(obj.eggGroup)
      ..writeByte(16)
      ..write(obj.genderRatio)
      ..writeByte(17)
      ..write(obj.eggGroups)
      ..writeByte(18)
      ..write(obj.typeDefenses)
      ..writeByte(19)
      ..write(obj.typeOffenses)
      ..writeByte(20)
      ..write(obj.evolutionChain);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PokemonDetailsHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
