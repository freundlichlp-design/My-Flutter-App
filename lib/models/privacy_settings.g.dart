// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'privacy_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrivacySettingsAdapter extends TypeAdapter<PrivacySettings> {
  @override
  final int typeId = 3;

  @override
  PrivacySettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrivacySettings(
      memoryEnabled: fields[0] as bool? ?? true,
      autoExtractFacts: fields[1] as bool? ?? true,
      storePersonalInfo: fields[2] as bool? ?? false,
      storePreferences: fields[3] as bool? ?? true,
      storeTechnicalFacts: fields[4] as bool? ?? true,
      maxMemoryEntries: fields[5] as int? ?? 500,
    );
  }

  @override
  void write(BinaryWriter writer, PrivacySettings obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.memoryEnabled)
      ..writeByte(1)
      ..write(obj.autoExtractFacts)
      ..writeByte(2)
      ..write(obj.storePersonalInfo)
      ..writeByte(3)
      ..write(obj.storePreferences)
      ..writeByte(4)
      ..write(obj.storeTechnicalFacts)
      ..writeByte(5)
      ..write(obj.maxMemoryEntries);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrivacySettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
