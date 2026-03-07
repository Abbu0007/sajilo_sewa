// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_profile_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProviderProfileHiveModelAdapter
    extends TypeAdapter<ProviderProfileHiveModel> {
  @override
  final int typeId = 9;

  @override
  ProviderProfileHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProviderProfileHiveModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      profession: fields[2] as String,
      bio: fields[3] as String?,
      startingPrice: fields[4] as double?,
      serviceAreas: (fields[5] as List).cast<String>(),
      availability: fields[6] as String,
      ratingAvg: fields[7] as double,
      ratingCount: fields[8] as double,
      completedJobs: fields[9] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ProviderProfileHiveModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.profession)
      ..writeByte(3)
      ..write(obj.bio)
      ..writeByte(4)
      ..write(obj.startingPrice)
      ..writeByte(5)
      ..write(obj.serviceAreas)
      ..writeByte(6)
      ..write(obj.availability)
      ..writeByte(7)
      ..write(obj.ratingAvg)
      ..writeByte(8)
      ..write(obj.ratingCount)
      ..writeByte(9)
      ..write(obj.completedJobs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProviderProfileHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
