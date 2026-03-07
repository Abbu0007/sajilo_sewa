// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_stats_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileStatsHiveModelAdapter extends TypeAdapter<ProfileStatsHiveModel> {
  @override
  final int typeId = 7;

  @override
  ProfileStatsHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileStatsHiveModel(
      ratingAvg: fields[0] as double,
      ratingCount: fields[1] as int,
      completedBookings: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ProfileStatsHiveModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.ratingAvg)
      ..writeByte(1)
      ..write(obj.ratingCount)
      ..writeByte(2)
      ..write(obj.completedBookings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileStatsHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
