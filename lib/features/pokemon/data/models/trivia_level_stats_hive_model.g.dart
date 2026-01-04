// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trivia_level_stats_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TriviaLevelStatsHiveModelAdapter
    extends TypeAdapter<TriviaLevelStatsHiveModel> {
  @override
  final int typeId = 10;

  @override
  TriviaLevelStatsHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TriviaLevelStatsHiveModel(
      level: fields[0] as int,
      correctAnswers: fields[1] as int,
      wrongAnswers: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TriviaLevelStatsHiveModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.level)
      ..writeByte(1)
      ..write(obj.correctAnswers)
      ..writeByte(2)
      ..write(obj.wrongAnswers);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TriviaLevelStatsHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
