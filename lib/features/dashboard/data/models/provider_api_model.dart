import '../../domain/entities/provider_entity.dart';

class ProviderApiModel {
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

  ProviderApiModel({
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

 factory ProviderApiModel.fromJson(Map<String, dynamic> json) {
  final profile = json['providerProfile'];

  int _safeInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is double) return v.toInt();
    return int.tryParse(v.toString()) ?? 0;
  }

  double _safeDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }

  return ProviderApiModel(
    id: json['_id'] ?? '',
    firstName: json['firstName'] ?? '',
    lastName: json['lastName'] ?? '',
    email: json['email'] ?? '',
    phone: json['phone'] ?? '',
    profession: json['profession'] ?? '',
    serviceSlug: json['serviceSlug'] ?? '',
    avatarUrl: json['avatarUrl'],

    avgRating: _safeDouble(json['avgRating'] ?? profile?['ratingAvg']),
    ratingCount: _safeInt(json['ratingCount'] ?? profile?['ratingCount']),
    completedJobs: _safeInt(json['completedJobs'] ?? profile?['completedJobs']),
    startingPrice: _safeInt(json['startingPrice'] ?? profile?['startingPrice']),
  );
}

  ProviderEntity toEntity() {
    return ProviderEntity(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      profession: profession,
      serviceSlug: serviceSlug,
      avatarUrl: avatarUrl,
      avgRating: avgRating,
      ratingCount: ratingCount,
      completedJobs: completedJobs,
      startingPrice: startingPrice,
    );
  }
}