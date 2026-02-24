class ProviderEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? email;
  final String? profession;
  final String? serviceSlug;
  final String? avatarUrl;
  final double avgRating;
  final int ratingCount;

  const ProviderEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.email,
    this.profession,
    this.serviceSlug,
    this.avatarUrl,
    this.avgRating = 0,
    this.ratingCount = 0,
  });

  String get fullName => ('$firstName $lastName').trim();
}