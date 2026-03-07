// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_notification_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProviderNotificationHiveModelAdapter
    extends TypeAdapter<ProviderNotificationHiveModel> {
  @override
  final int typeId = 11;

  @override
  ProviderNotificationHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProviderNotificationHiveModel(
      id: fields[0] as String,
      type: fields[1] as String?,
      title: fields[2] as String,
      message: fields[3] as String,
      createdAt: fields[4] as String?,
      isRead: fields[5] as bool,
      bookingId: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProviderNotificationHiveModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.message)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.isRead)
      ..writeByte(6)
      ..write(obj.bookingId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProviderNotificationHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
