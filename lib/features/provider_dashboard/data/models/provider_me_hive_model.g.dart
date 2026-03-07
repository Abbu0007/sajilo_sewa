// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_me_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProviderMeHiveModelAdapter extends TypeAdapter<ProviderMeHiveModel> {
  @override
  final int typeId = 8;

  @override
  ProviderMeHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProviderMeHiveModel(
      id: fields[0] as String,
      firstName: fields[1] as String,
      lastName: fields[2] as String,
      email: fields[3] as String?,
      phone: fields[4] as String?,
      avatarUrl: fields[5] as String?,
      role: fields[6] as String?,
      profession: fields[7] as String?,
      avgRating: fields[8] as double?,
      ratingCount: fields[9] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, ProviderMeHiveModel obj) {
    writer
      ..writeByte(10)
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
      ..write(obj.avatarUrl)
      ..writeByte(6)
      ..write(obj.role)
      ..writeByte(7)
      ..write(obj.profession)
      ..writeByte(8)
      ..write(obj.avgRating)
      ..writeByte(9)
      ..write(obj.ratingCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProviderMeHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
