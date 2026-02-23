class AdminUserEntity {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final String? profession;
  final String? avatarUrl;

  const AdminUserEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    this.profession,
    this.avatarUrl,
  });

  AdminUserEntity copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? role,
    String? profession,
    String? avatarUrl,
  }) {
    return AdminUserEntity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      profession: profession ?? this.profession,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
