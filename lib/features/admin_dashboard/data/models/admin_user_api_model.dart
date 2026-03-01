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
  final String? serviceSlug;
  final String? avatarUrl;

  final double ratingAvg;
  final int ratingCount;
  final int completedBookings;

  AdminUserApiModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.role,
    this.profession,
    this.serviceSlug,
    this.avatarUrl,
    this.ratingAvg = 0.0,
    this.ratingCount = 0,
    this.completedBookings = 0,
  });

  String get fullName => '$firstName $lastName'.trim();

  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString()) ?? 0;
  }

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
      serviceSlug: json['serviceSlug']?.toString(),
      ratingAvg: _toDouble(json['ratingAvg']),
      ratingCount: _toInt(json['ratingCount']),
      completedBookings: _toInt(json['completedBookings']),
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
        serviceSlug: serviceSlug,
        avatarUrl: avatarUrl,
        ratingAvg: ratingAvg,
        ratingCount: ratingCount,
        completedBookings: completedBookings,
      );
}