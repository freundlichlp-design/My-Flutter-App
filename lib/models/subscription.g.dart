// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubscriptionAdapter extends TypeAdapter<Subscription> {
  @override
  final int typeId = 2;

  @override
  Subscription read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Subscription(
      tier: fields[0] as String,
      messagesUsedToday: fields[1] as int,
      lastResetDate: fields[2] as DateTime,
      premiumExpiryDate: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Subscription obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.tier)
      ..writeByte(1)
      ..write(obj.messagesUsedToday)
      ..writeByte(2)
      ..write(obj.lastResetDate)
      ..writeByte(3)
      ..write(obj.premiumExpiryDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubscriptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
