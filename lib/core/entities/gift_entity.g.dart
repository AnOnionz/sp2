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
      switch(fields[0] as int){
  case 1: return Nen(
  giftId: fields[0] as int,
  name: fields[1] as String,
  image: fields[2] as String,
  amountCurrent: fields[3] as int,
  );
  case 2: return Voucher(
  giftId: fields[0] as int,
  name: fields[1] as String,
  image: fields[2] as String,
  amountCurrent: fields[3] as int,
  );
  case 3: return StrongBowGift(
  giftId: fields[0] as int,
  name: fields[1] as String,
  image: fields[2] as String,
  amountCurrent: fields[3] as int,
  );
  case 4: return Pack4(
  giftId: fields[0] as int,
  name: fields[1] as String,
  image: fields[2] as String,
  amountCurrent: fields[3] as int,
  );
  case 5: return Pack6(
  giftId: fields[0] as int,
  name: fields[1] as String,
  image: fields[2] as String,
  amountCurrent: fields[3] as int,
  );
  case 6: return Alu(
  giftId: fields[0] as int,
  name: fields[1] as String,
  image: fields[2] as String,
  amountCurrent: fields[3] as int,
  );
  case 7: return Magnum(
  giftId: fields[0] as int,
  name: fields[1] as String,
  image: fields[2] as String,
  amountCurrent: fields[3] as int,
  );
  }
    return GiftEntity(
      giftId: fields[0] as int,
      name: fields[1] as String,
      image: fields[2] as String,
      amountCurrent: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, GiftEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.giftId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
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
