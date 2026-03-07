import 'package:hive/hive.dart';

part 'provider_profile_hive_model.g.dart';

@HiveType(typeId: 9)
class ProviderProfileHiveModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String profession;

  @HiveField(3)
  final String? bio;

  @HiveField(4)
  final double? startingPrice;

  @HiveField(5)
  final List<String> serviceAreas;

  @HiveField(6)
  final String availability;

  @HiveField(7)
  final double ratingAvg;

  @HiveField(8)
  final double ratingCount;

  @HiveField(9)
  final double completedJobs;

  const ProviderProfileHiveModel({
    required this.id,
    required this.userId,
    required this.profession,
    this.bio,
    this.startingPrice,
    required this.serviceAreas,
    required this.availability,
    required this.ratingAvg,
    required this.ratingCount,
    required this.completedJobs,
  });
}