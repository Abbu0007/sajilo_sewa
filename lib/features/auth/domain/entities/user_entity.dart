class UserEntity {
  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String userType; // client | provider
  final String? service; // only for provider

  const UserEntity({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.userType,
    this.service,
  });
}
