class ProviderMeEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String? email;
  final String? phone;
  final String? avatarUrl;
  final String? role;
  final String? profession;
  final num? avgRating;
  final num? ratingCount;

  const ProviderMeEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phone,
    this.avatarUrl,
    this.role,
    this.profession,
    this.avgRating,
    this.ratingCount,
  });

  String get fullName => ('$firstName $lastName').trim();
}