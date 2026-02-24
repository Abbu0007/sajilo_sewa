class ProviderProfileApiModel {
  final String id;
  final String userId;
  final String profession;
  final String? bio;
  final num? startingPrice;
  final List<String> serviceAreas;
  final String availability; // available | busy | offline
  final num ratingAvg;
  final num ratingCount;
  final num completedJobs;

  ProviderProfileApiModel({
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

  factory ProviderProfileApiModel.fromJson(Map<String, dynamic> json) {
    String? norm(String? v) {
      final s = (v ?? '').trim();
      return s.isEmpty ? null : s;
    }

    num num0(dynamic v) => (v is num) ? v : 0;

    final areasRaw = json['serviceAreas'];
    final List<String> areas = (areasRaw is List)
        ? areasRaw.map((e) => e.toString()).where((e) => e.trim().isNotEmpty).toList()
        : <String>[];

    return ProviderProfileApiModel(
      id: json['_id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      profession: json['profession']?.toString() ?? '',
      bio: norm(json['bio']?.toString()),
      startingPrice: (json['startingPrice'] is num) ? json['startingPrice'] as num : null,
      serviceAreas: areas,
      availability: json['availability']?.toString() ?? 'available',
      ratingAvg: num0(json['ratingAvg']),
      ratingCount: num0(json['ratingCount']),
      completedJobs: num0(json['completedJobs']),
    );
  }
}