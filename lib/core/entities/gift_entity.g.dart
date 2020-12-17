// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GiftEntityAdapter extends TypeAdapter<GiftEntity> {
  @override
  final int typeId = 7;

  @override
  GiftEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GiftEntity(
      giftId: fields[0] as int,
      name: fields[1] as String,
      code: fields[2] as String,
      image: fields[3] as String,
      amountCurrent: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, GiftEntity obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.giftId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.code)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.amountCurrent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is GiftEntityAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}