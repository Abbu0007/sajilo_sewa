class ProviderMeApiModel {
  final String id;
  final String firstName;
  final String lastName;
  final String? email;
  final String? phone;
  final String? avatarUrl;
  final String? role;
  final num? avgRating;
  final num? ratingCount;

  ProviderMeApiModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phone,
    this.avatarUrl,
    this.role,
    this.avgRating,
    this.ratingCount,
  });

  factory ProviderMeApiModel.fromJson(Map<String, dynamic> json) {
    String? norm(String? v) {
      final s = (v ?? '').trim();
      return s.isEmpty ? null : s;
    }

    num? numSafe(dynamic v) {
      if (v is num) return v;
      return null;
    }

    return ProviderMeApiModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      email: norm(json['email']?.toString()),
      phone: norm(json['phone']?.toString()),
      avatarUrl: norm(json['avatarUrl']?.toString()),
      role: norm(json['role']?.toString()),
      avgRating: numSafe(json['avgRating']),
      ratingCount: numSafe(json['ratingCount']),
    );
  }
}