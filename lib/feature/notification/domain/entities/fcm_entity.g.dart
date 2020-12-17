// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fcm_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FcmEntityAdapter extends TypeAdapter<FcmEntity> {
  @override
  final int typeId = 3;

  @override
  FcmEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FcmEntity(
      title: fields[0] as String,
      body: fields[1] as String,
      tab: fields[2] as int,
      screen: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FcmEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.body)
      ..writeByte(2)
      ..write(obj.tab)
      ..writeByte(3)
      ..write(obj.screen);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FcmEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
