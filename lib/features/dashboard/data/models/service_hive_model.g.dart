// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ServiceHiveModelAdapter extends TypeAdapter<ServiceHiveModel> {
  @override
  final int typeId = 2;

  @override
  ServiceHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ServiceHiveModel(
      id: fields[0] as String,
      name: fields[1] as String,
      slug: fields[2] as String,
      icon: fields[3] as String?,
      basePriceFrom: fields[4] as num?,
    );
  }

  @override
  void write(BinaryWriter writer, ServiceHiveModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.slug)
      ..writeByte(3)
      ..write(obj.icon)
      ..writeByte(4)
      ..write(obj.basePriceFrom);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
