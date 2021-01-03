// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'highlight_cache_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HighlightCacheEntityAdapter extends TypeAdapter<HighlightCacheEntity> {
  @override
  final int typeId = 1;

  @override
  HighlightCacheEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HighlightCacheEntity(
      outletCode: fields[8] as String,
      workContent: fields[0] as String,
      rivalContent: fields[1] as String,
      posmContent: fields[2] as String,
      giftContent: fields[3] as String,
      workImages: (fields[4] as List)?.cast<String>(),
      rivalImages: (fields[5] as List)?.cast<String>(),
      posmImages: (fields[6] as List)?.cast<String>(),
      giftImages: (fields[7] as List)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, HighlightCacheEntity obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.workContent)
      ..writeByte(1)
      ..write(obj.rivalContent)
      ..writeByte(2)
      ..write(obj.posmContent)
      ..writeByte(3)
      ..write(obj.giftContent)
      ..writeByte(4)
      ..write(obj.workImages)
      ..writeByte(5)
      ..write(obj.rivalImages)
      ..writeByte(6)
      ..write(obj.posmImages)
      ..writeByte(7)
      ..write(obj.giftImages)
      ..writeByte(8)
      ..write(obj.outletCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HighlightCacheEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
