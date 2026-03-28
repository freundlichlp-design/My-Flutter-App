// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MemoryEntryAdapter extends TypeAdapter<MemoryEntry> {
  @override
  final int typeId = 2;

  @override
  MemoryEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MemoryEntry(
      id: fields[0] as String,
      fact: fields[1] as String,
      category: fields[2] as String,
      sourceConversationId: fields[3] as String,
      extractedAt: fields[4] as DateTime,
      isPrivate: fields[5] as bool? ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, MemoryEntry obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fact)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.sourceConversationId)
      ..writeByte(4)
      ..write(obj.extractedAt)
      ..writeByte(5)
      ..write(obj.isPrivate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemoryEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
