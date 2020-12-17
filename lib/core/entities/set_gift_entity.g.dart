// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_gift_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SetGiftEntityAdapter extends TypeAdapter<SetGiftEntity> {
  @override
  final int typeId = 10;

  @override
  SetGiftEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SetGiftEntity(
      index: fields[0] as int,
      gifts: (fields[1] as List)?.cast<GiftEntity>(),
    );
  }

  @override
  void write(BinaryWriter writer, SetGiftEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.index)
      ..writeByte(1)
      ..write(obj.gifts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SetGiftEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
