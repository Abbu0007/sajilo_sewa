import 'package:hive/hive.dart';

part 'provider_me_hive_model.g.dart';

@HiveType(typeId: 8)
class ProviderMeHiveModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String firstName;

  @HiveField(2)
  final String lastName;

  @HiveField(3)
  final String? email;

  @HiveField(4)
  final String? phone;

  @HiveField(5)
  final String? avatarUrl;

  @HiveField(6)
  final String? role;

  @HiveField(7)
  final String? profession;

  @HiveField(8)
  final double? avgRating;

  @HiveField(9)
  final double? ratingCount;

  const ProviderMeHiveModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phone,
    this.avatarUrl,
    this.role,
    this.profession,
    this.avgRating,
    this.ratingCount,
  });
}