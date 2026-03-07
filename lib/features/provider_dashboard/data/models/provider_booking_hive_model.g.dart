// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_booking_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProviderBookingHiveModelAdapter
    extends TypeAdapter<ProviderBookingHiveModel> {
  @override
  final int typeId = 10;

  @override
  ProviderBookingHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProviderBookingHiveModel(
      id: fields[0] as String,
      status: fields[1] as String,
      scheduledAt: fields[2] as String,
      note: fields[3] as String?,
      addressText: fields[4] as String?,
      price: fields[5] as double?,
      paymentStatus: fields[6] as String?,
      clientId: fields[7] as String?,
      clientFirstName: fields[8] as String?,
      clientLastName: fields[9] as String?,
      clientPhone: fields[10] as String?,
      clientEmail: fields[11] as String?,
      clientAvatarUrl: fields[12] as String?,
      serviceId: fields[13] as String?,
      serviceName: fields[14] as String?,
      serviceIcon: fields[15] as String?,
      serviceBasePriceFrom: fields[16] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, ProviderBookingHiveModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.scheduledAt)
      ..writeByte(3)
      ..write(obj.note)
      ..writeByte(4)
      ..write(obj.addressText)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.paymentStatus)
      ..writeByte(7)
      ..write(obj.clientId)
      ..writeByte(8)
      ..write(obj.clientFirstName)
      ..writeByte(9)
      ..write(obj.clientLastName)
      ..writeByte(10)
      ..write(obj.clientPhone)
      ..writeByte(11)
      ..write(obj.clientEmail)
      ..writeByte(12)
      ..write(obj.clientAvatarUrl)
      ..writeByte(13)
      ..write(obj.serviceId)
      ..writeByte(14)
      ..write(obj.serviceName)
      ..writeByte(15)
      ..write(obj.serviceIcon)
      ..writeByte(16)
      ..write(obj.serviceBasePriceFrom);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProviderBookingHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
