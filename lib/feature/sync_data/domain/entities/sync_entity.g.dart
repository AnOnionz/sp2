// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SyncEntityAdapter extends TypeAdapter<SyncEntity> {
  @override
  final int typeId = 6;

  @override
  SyncEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SyncEntity(
      nonSynchronized: fields[0] as int,
      synchronized: fields[1] as int,
      imageNonSynchronized: fields[2] as int,
      imageSynchronized: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SyncEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.nonSynchronized)
      ..writeByte(1)
      ..write(obj.synchronized)
      ..writeByte(2)
      ..write(obj.imageNonSynchronized)
      ..writeByte(3)
      ..write(obj.imageSynchronized);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SyncEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
