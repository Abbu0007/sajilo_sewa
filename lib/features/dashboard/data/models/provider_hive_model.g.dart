// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProviderHiveModelAdapter extends TypeAdapter<ProviderHiveModel> {
  @override
  final int typeId = 3;

  @override
  ProviderHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProviderHiveModel(
      id: fields[0] as String,
      firstName: fields[1] as String,
      lastName: fields[2] as String,
      email: fields[3] as String,
      phone: fields[4] as String,
      profession: fields[5] as String,
      serviceSlug: fields[6] as String,
      avatarUrl: fields[7] as String?,
      avgRating: fields[8] as double,
      ratingCount: fields[9] as int,
      completedJobs: fields[10] as int,
      startingPrice: fields[11] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ProviderHiveModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.email)
      ..writeByte(4)
      ..write(obj.phone)
      ..writeByte(5)
      ..write(obj.profession)
      ..writeByte(6)
      ..write(obj.serviceSlug)
      ..writeByte(7)
      ..write(obj.avatarUrl)
      ..writeByte(8)
      ..write(obj.avgRating)
      ..writeByte(9)
      ..write(obj.ratingCount)
      ..writeByte(10)
      ..write(obj.completedJobs)
      ..writeByte(11)
      ..write(obj.startingPrice);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProviderHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
