// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookingHiveModelAdapter extends TypeAdapter<BookingHiveModel> {
  @override
  final int typeId = 4;

  @override
  BookingHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BookingHiveModel(
      id: fields[0] as String,
      status: fields[1] as String,
      scheduledAt: fields[2] as String,
      note: fields[3] as String?,
      addressText: fields[4] as String?,
      price: fields[5] as double?,
      paymentStatus: fields[6] as String?,
      providerId: fields[7] as String?,
      providerFirstName: fields[8] as String?,
      providerLastName: fields[9] as String?,
      providerEmail: fields[10] as String?,
      providerPhone: fields[11] as String?,
      providerProfession: fields[12] as String?,
      providerServiceSlug: fields[13] as String?,
      providerAvatarUrl: fields[14] as String?,
      providerAvgRating: fields[15] as double?,
      providerRatingCount: fields[16] as int?,
      providerCompletedJobs: fields[17] as int?,
      providerStartingPrice: fields[18] as int?,
      serviceId: fields[19] as String?,
      serviceName: fields[20] as String?,
      serviceSlug: fields[21] as String?,
      serviceIcon: fields[22] as String?,
      serviceBasePriceFrom: fields[23] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, BookingHiveModel obj) {
    writer
      ..writeByte(24)
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
      ..write(obj.providerId)
      ..writeByte(8)
      ..write(obj.providerFirstName)
      ..writeByte(9)
      ..write(obj.providerLastName)
      ..writeByte(10)
      ..write(obj.providerEmail)
      ..writeByte(11)
      ..write(obj.providerPhone)
      ..writeByte(12)
      ..write(obj.providerProfession)
      ..writeByte(13)
      ..write(obj.providerServiceSlug)
      ..writeByte(14)
      ..write(obj.providerAvatarUrl)
      ..writeByte(15)
      ..write(obj.providerAvgRating)
      ..writeByte(16)
      ..write(obj.providerRatingCount)
      ..writeByte(17)
      ..write(obj.providerCompletedJobs)
      ..writeByte(18)
      ..write(obj.providerStartingPrice)
      ..writeByte(19)
      ..write(obj.serviceId)
      ..writeByte(20)
      ..write(obj.serviceName)
      ..writeByte(21)
      ..write(obj.serviceSlug)
      ..writeByte(22)
      ..write(obj.serviceIcon)
      ..writeByte(23)
      ..write(obj.serviceBasePriceFrom);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookingHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
