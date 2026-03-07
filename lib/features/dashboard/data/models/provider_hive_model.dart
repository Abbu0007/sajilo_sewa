import 'package:hive/hive.dart';

part 'provider_hive_model.g.dart';

@HiveType(typeId: 3)
class ProviderHiveModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String firstName;

  @HiveField(2)
  final String lastName;

  @HiveField(3)
  final String email;

  @HiveField(4)
  final String phone;

  @HiveField(5)
  final String profession;

  @HiveField(6)
  final String serviceSlug;

  @HiveField(7)
  final String? avatarUrl;

  @HiveField(8)
  final double avgRating;

  @HiveField(9)
  final int ratingCount;

  @HiveField(10)
  final int completedJobs;

  @HiveField(11)
  final int startingPrice;

  const ProviderHiveModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.profession,
    required this.serviceSlug,
    required this.avatarUrl,
    required this.avgRating,
    required this.ratingCount,
    required this.completedJobs,
    required this.startingPrice,
  });
}