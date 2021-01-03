// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'today_data_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DataTodayEntityAdapter extends TypeAdapter<DataTodayEntity> {
  @override
  final int typeId = 15;

  @override
  DataTodayEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataTodayEntity(
      checkIn: fields[0] as bool,
      checkOut: fields[1] as bool,
      inventory: fields[2] as bool,
      highLight: fields[3] as bool,
      inventoryEntity: fields[5] as InventoryEntity,
      highlightCached: fields[4] as HighlightCacheEntity,
    );
  }

  @override
  void write(BinaryWriter writer, DataTodayEntity obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.checkIn)
      ..writeByte(1)
      ..write(obj.checkOut)
      ..writeByte(2)
      ..write(obj.inventory)
      ..writeByte(3)
      ..write(obj.highLight)
      ..writeByte(4)
      ..write(obj.highlightCached)
      ..writeByte(5)
      ..write(obj.inventoryEntity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataTodayEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
