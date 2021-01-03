// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductEntityAdapter extends TypeAdapter<ProductEntity> {
  @override
  final int typeId = 8;

  @override
  ProductEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
      switch(fields[0] as int){
  case 8: return HeinekenNormal(
  productId: fields[0] as int,
  productName: fields[1] as String,
  count: fields[4] as int ?? 0,
  price: fields[3] as int ?? 0,
  imgUrl: fields[2] as String,
  );
  case 9: return Heineken0(
  productId: fields[0] as int,
  productName: fields[1] as String,
  count: fields[4] as int ?? 0,
  price: fields[3] as int ?? 0,
  imgUrl: fields[2] as String,
  );
  case 10: return HeinekenSilver(
  productId: fields[0] as int,
  productName: fields[1] as String,
  count: fields[4] as int ?? 0,
  price: fields[3] as int ?? 0,
  imgUrl: fields[2] as String,
  );
  case 11: return TigerNormal(
  productId: fields[0] as int,
  productName: fields[1] as String,
  count: fields[4] as int ?? 0,
  price: fields[3] as int ?? 0,
  imgUrl: fields[2] as String,
  );
  case 12: return TigerCrystal(
  productId: fields[0] as int,
  productName: fields[1] as String,
  count: fields[4] as int ?? 0,
  price: fields[3] as int ?? 0,
  imgUrl: fields[2] as String,
  );
  case 13: return StrongBow(
  productId: fields[0] as int,
  productName: fields[1] as String,
  count: fields[4] as int ?? 0,
  price: fields[3] as int ?? 0,
  imgUrl: fields[2] as String,
  );
  case 14: return Larue(
  productId: fields[0] as int,
  productName: fields[1] as String,
  count: fields[4] as int ?? 0,
  price: fields[3] as int ?? 0,
  imgUrl: fields[2] as String,
  );
  case 15: return BiaViet(
  productId: fields[0] as int,
  productName: fields[1] as String,
  count: fields[4] as int ?? 0,
  price: fields[3] as int ?? 0,
  imgUrl: fields[2] as String,
  );
  case 16: return Bivina(
  productId: fields[0] as int,
  productName: fields[1] as String,
  count: fields[4] as int ?? 0,
  price: fields[3] as int ?? 0,
  imgUrl: fields[2] as String,
  );

  }
    return ProductEntity(
      productId: fields[0] as int,
      productName: fields[1] as String,
      count: fields[4] as int,
      price: fields[3] as int,
      imgUrl: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ProductEntity obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.productName)
      ..writeByte(2)
      ..write(obj.imgUrl)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.count);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
