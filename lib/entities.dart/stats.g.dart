// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stats.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StatsEntityAdapter extends TypeAdapter<StatsEntity> {
  @override
  final int typeId = 4;

  @override
  StatsEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StatsEntity(
      fields[0] as DateTime,
      (fields[1] as Map).cast<MemorizationState, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, StatsEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.states);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatsEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
