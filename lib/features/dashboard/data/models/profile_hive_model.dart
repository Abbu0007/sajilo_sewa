import 'package:hive/hive.dart';

part 'profile_hive_model.g.dart';

@HiveType(typeId: 6)
class ProfileHiveModel {
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
  final String role;

  @HiveField(6)
  final String? profession;

  @HiveField(7)
  final String? avatarUrl;

  const ProfileHiveModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.role,
    this.profession,
    this.avatarUrl,
  });
}