// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receive_gift_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReceiveGiftEntityAdapter extends TypeAdapter<ReceiveGiftEntity> {
  @override
  final int typeId = 5;

  @override
  ReceiveGiftEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReceiveGiftEntity(
      customer: fields[0] as CustomerEntity,
      products: (fields[1] as List)?.cast<ProductEntity>(),
      giftReceived: (fields[2] as List)?.cast<GiftEntity>(),
      createAt: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ReceiveGiftEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.customer)
      ..writeByte(1)
      ..write(obj.products)
      ..writeByte(2)
      ..write(obj.giftReceived)
      ..writeByte(3)
      ..write(obj.createAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReceiveGiftEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
