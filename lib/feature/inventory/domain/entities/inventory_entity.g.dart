// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InventoryEntityAdapter extends TypeAdapter<InventoryEntity> {
  @override
  final int typeId = 2;

  @override
  InventoryEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InventoryEntity(
      inInventory: (fields[0] as List)?.cast<dynamic>(),
      outInventory: (fields[1] as List)?.cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, InventoryEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.inInventory)
      ..writeByte(1)
      ..write(obj.outInventory);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InventoryEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
