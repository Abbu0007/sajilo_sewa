class ProfileEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String role;
  final String? profession;
  final String? avatarUrl;

  const ProfileEntity({
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
}
