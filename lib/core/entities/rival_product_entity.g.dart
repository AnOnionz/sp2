// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rival_product_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RivalProductEntityAdapter extends TypeAdapter<RivalProductEntity> {
  @override
  final int typeId = 9;

  @override
  RivalProductEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RivalProductEntity(
      name: fields[0] as String,
      price: fields[1] as int,
      imgUrl: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RivalProductEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.price)
      ..writeByte(2)
      ..write(obj.imgUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RivalProductEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
