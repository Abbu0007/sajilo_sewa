import 'package:sajilo_sewa/core/utils/url_utils.dart';
import 'package:sajilo_sewa/features/profile/domain/entities/profile_entity.dart';

class ProfileApiModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String role;
  final String? profession;
  final String? avatarUrl;

  const ProfileApiModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.role,
    this.profession,
    this.avatarUrl,
  });

  String get fullName => '$firstName $lastName'.trim();

  factory ProfileApiModel.fromJson(Map<String, dynamic> json) {
    return ProfileApiModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      firstName: (json['firstName'] ?? '').toString(),
      lastName: (json['lastName'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      role: (json['role'] ?? '').toString(),
      profession: json['profession']?.toString(),
      avatarUrl: UrlUtils.normalizeMediaUrl(json['avatarUrl']?.toString()),
    );
  }

  ProfileEntity toEntity() {
    return ProfileEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      role: role,
      profession: profession,
      avatarUrl: avatarUrl,
    );
  }
}
