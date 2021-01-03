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
      id: fields[0] as int,
      name: fields[1] as String,
      price: fields[2] as int,
      imgUrl: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RivalProductEntity obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
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
