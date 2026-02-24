class ProviderApiModel {
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

  ProviderApiModel({
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

  factory ProviderApiModel.fromJson(Map<String, dynamic> json) {
    String? normalize(String? v) {
      final s = (v ?? '').trim();
      return s.isEmpty ? null : s;
    }

    double readDouble(dynamic v) {
      if (v == null) return 0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0;
    }

    int readInt(dynamic v) {
      if (v == null) return 0;
      if (v is num) return v.toInt();
      return int.tryParse(v.toString()) ?? 0;
    }

    return ProviderApiModel(
      id: json['_id']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      phone: normalize(json['phone']?.toString()),
      email: normalize(json['email']?.toString()),
      profession: normalize(json['profession']?.toString()),
      serviceSlug: normalize(json['serviceSlug']?.toString()),
      avatarUrl: normalize(json['avatarUrl']?.toString()),
      avgRating: readDouble(json['avgRating']),
      ratingCount: readInt(json['ratingCount']),
    );
  }
}