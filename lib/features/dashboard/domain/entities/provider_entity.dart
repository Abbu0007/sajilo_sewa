class ProviderEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String profession;
  final String serviceSlug;
  final String? avatarUrl;

  final double avgRating;
  final int ratingCount;
  final int completedJobs;
  final int startingPrice;

  ProviderEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.profession,
    required this.serviceSlug,
    required this.avatarUrl,
    required this.avgRating,
    required this.ratingCount,
    required this.completedJobs,
    required this.startingPrice,
  });

  String get fullName => "$firstName $lastName";
}