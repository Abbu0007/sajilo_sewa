import 'package:sajilo_sewa/features/admin_dashboard/domain/entities/admin_user_entity.dart';
import 'package:sajilo_sewa/core/utils/url_utils.dart';

class AdminUserApiModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String role;
  final String? profession;
  final String? avatarUrl;

  AdminUserApiModel({
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

  factory AdminUserApiModel.fromJson(Map<String, dynamic> json) {
    final rawAvatar =
        (json['avatarUrl'] ?? json['avatar'] ?? json['profileImage'] ?? json['image'])?.toString();

    return AdminUserApiModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      firstName: (json['firstName'] ?? '').toString(),
      lastName: (json['lastName'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      role: (json['role'] ?? '').toString(),
      profession: json['profession']?.toString(),
      avatarUrl: rawAvatar == null || rawAvatar.isEmpty
          ? null
          : UrlUtils.normalizeMediaUrl(rawAvatar),
    );
  }

  AdminUserEntity toEntity() => AdminUserEntity(
        id: id,
        fullName: fullName,
        email: email,
        phone: phone,
        role: role,
        profession: profession,
        avatarUrl: avatarUrl,
      );
}
