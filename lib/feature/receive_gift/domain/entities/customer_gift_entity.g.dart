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
      productImage: (fields[4] as List)?.cast<String>(),
      customerImage: (fields[5] as List)?.cast<String>(),
      receiptImage: (fields[6] as List)?.cast<String>(),
      voucherPhone: fields[8] as String,
      voucherQty: fields[9] as int,
      voucherReceived: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CustomerGiftEntity obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.outletCode)
      ..writeByte(1)
      ..write(obj.customer)
      ..writeByte(2)
      ..write(obj.products)
      ..writeByte(3)
      ..write(obj.gifts)
      ..writeByte(4)
      ..write(obj.productImage)
      ..writeByte(5)
      ..write(obj.customerImage)
      ..writeByte(6)
      ..write(obj.receiptImage)
      ..writeByte(7)
      ..write(obj.voucherReceived)
      ..writeByte(8)
      ..write(obj.voucherPhone)
      ..writeByte(9)
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
