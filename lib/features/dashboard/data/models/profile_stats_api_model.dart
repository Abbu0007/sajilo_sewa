class ProfileStatsApiModel {
  final double ratingAvg;
  final int ratingCount;
  final int completedBookings;

  const ProfileStatsApiModel({
    required this.ratingAvg,
    required this.ratingCount,
    required this.completedBookings,
  });

  factory ProfileStatsApiModel.fromJson(Map<String, dynamic> json) {
    return ProfileStatsApiModel(
      ratingAvg: ((json['ratingAvg'] ?? 0) as num).toDouble(),
      ratingCount: (json['ratingCount'] ?? 0) as int,
      completedBookings: (json['completedBookings'] ?? 0) as int,
    );
  }
}