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
      date: fields[0] as DateTime,
      inInvetory: (fields[1] as HiveList)?.castHiveList(),
      outInventory: (fields[2] as HiveList)?.castHiveList(),
    );
  }

  @override
  void write(BinaryWriter writer, InventoryEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.inInvetory)
      ..writeByte(2)
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
