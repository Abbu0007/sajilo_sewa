class AdminUserEntity {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String role;

  final String? profession;
  final String? serviceSlug;
  final String? avatarUrl;

  final double ratingAvg;
  final int ratingCount;
  final int completedBookings;

  const AdminUserEntity({
    required this.id,
    required this.fullName,
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

  AdminUserEntity copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? role,
    String? profession,
    String? serviceSlug,
    String? avatarUrl,
    double? ratingAvg,
    int? ratingCount,
    int? completedBookings,
  }) {
    return AdminUserEntity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      profession: profession ?? this.profession,
      serviceSlug: serviceSlug ?? this.serviceSlug,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      ratingAvg: ratingAvg ?? this.ratingAvg,
      ratingCount: ratingCount ?? this.ratingCount,
      completedBookings: completedBookings ?? this.completedBookings,
    );
  }
}