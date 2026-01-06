import 'package:hive/hive.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: 1)
class UserHiveModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String fullName;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String password;

  @HiveField(4)
  final String role; // client | provider | admin

  @HiveField(5)
  final String? profession; // only for provider

  @HiveField(6)
  final DateTime createdAt;

  UserHiveModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.password,
    required this.role,
    this.profession,
    required this.createdAt,
  });
}
