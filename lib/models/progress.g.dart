// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProgressAdapter extends TypeAdapter<Progress> {
  @override
  final int typeId = 3;

  @override
  Progress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Progress(
      fields[0] as String,
      ease: fields[2] as double,
      interval: fields[1] as int,
      repetitions: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Progress obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.interval)
      ..writeByte(2)
      ..write(obj.ease)
      ..writeByte(3)
      ..write(obj.repetitions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
