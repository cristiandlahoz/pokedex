// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trivia_player_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TriviaPlayerHiveModelAdapter extends TypeAdapter<TriviaPlayerHiveModel> {
  @override
  final int typeId = 9;

  @override
  TriviaPlayerHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TriviaPlayerHiveModel(
      name: fields[0] as String,
      createdAt: fields[1] as DateTime,
      lastPlayedAt: fields[2] as DateTime,
      levelStats: (fields[3] as Map).cast<int, TriviaLevelStatsHiveModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, TriviaPlayerHiveModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.lastPlayedAt)
      ..writeByte(3)
      ..write(obj.levelStats);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TriviaPlayerHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
