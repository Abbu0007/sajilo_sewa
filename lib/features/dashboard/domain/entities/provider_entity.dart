class ProviderEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? email;
  final String? profession;
  final String? serviceSlug;
  final String? avatarUrl;

  const ProviderEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.email,
    this.profession,
    this.serviceSlug,
    this.avatarUrl,
  });

  String get fullName => ('$firstName $lastName').trim();
}