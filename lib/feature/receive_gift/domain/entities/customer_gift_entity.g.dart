// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_gift_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomerGiftEntityAdapter extends TypeAdapter<CustomerGiftEntity> {
  @override
  final int typeId = 20;

  @override
  CustomerGiftEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomerGiftEntity(
      outletCode: fields[0] as String,
      customer: fields[1] as CustomerEntity,
      products: (fields[2] as List)?.cast<dynamic>(),
      gifts: (fields[3] as List)?.cast<dynamic>(),
      customerImage: (fields[4] as List)?.cast<String>(),
      voucherPhone: fields[6] as String,
      voucherQty: fields[7] as int,
      voucherReceived: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CustomerGiftEntity obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.outletCode)
      ..writeByte(1)
      ..write(obj.customer)
      ..writeByte(2)
      ..write(obj.products)
      ..writeByte(3)
      ..write(obj.gifts)
      ..writeByte(4)
      ..write(obj.customerImage)
      ..writeByte(5)
      ..write(obj.voucherReceived)
      ..writeByte(6)
      ..write(obj.voucherPhone)
      ..writeByte(7)
      ..write(obj.voucherQty);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerGiftEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
