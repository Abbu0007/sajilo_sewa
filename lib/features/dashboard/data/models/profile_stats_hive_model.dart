import 'package:hive/hive.dart';

part 'profile_stats_hive_model.g.dart';

@HiveType(typeId: 7)
class ProfileStatsHiveModel {
  @HiveField(0)
  final double ratingAvg;

  @HiveField(1)
  final int ratingCount;

  @HiveField(2)
  final int completedBookings;

  const ProfileStatsHiveModel({
    required this.ratingAvg,
    required this.ratingCount,
    required this.completedBookings,
  });
}