// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memorization.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MemorizationStateAdapter extends TypeAdapter<MemorizationState> {
  @override
  final int typeId = 2;

  @override
  MemorizationState read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MemorizationState.good;
      case 1:
        return MemorizationState.forget;
      case 2:
        return MemorizationState.easy;
      default:
        return MemorizationState.good;
    }
  }

  @override
  void write(BinaryWriter writer, MemorizationState obj) {
    switch (obj) {
      case MemorizationState.good:
        writer.writeByte(0);
        break;
      case MemorizationState.forget:
        writer.writeByte(1);
        break;
      case MemorizationState.easy:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemorizationStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
