class ProviderProfileEntity {
  final String id;
  final String userId;
  final String profession;
  final String? bio;
  final num? startingPrice;
  final List<String> serviceAreas;
  final String availability;

  final num ratingAvg;
  final num ratingCount;
  final num completedJobs;

  const ProviderProfileEntity({
    required this.id,
    required this.userId,
    required this.profession,
    this.bio,
    this.startingPrice,
    required this.serviceAreas,
    required this.availability,
    required this.ratingAvg,
    required this.ratingCount,
    required this.completedJobs,
  });
}