// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'highlight_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HighlightEntityAdapter extends TypeAdapter<HighlightEntity> {
  @override
  final int typeId = 1;

  @override
  HighlightEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HighlightEntity(
      title: fields[0] as String,
      content: fields[1] as String,
      images: (fields[2] as List)?.cast<File>(),
    );
  }

  @override
  void write(BinaryWriter writer, HighlightEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.images);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HighlightEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
