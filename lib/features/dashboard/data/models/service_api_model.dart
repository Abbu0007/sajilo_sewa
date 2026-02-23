class ServiceApiModel {
  final String id;
  final String name;
  final String slug;
  final String? icon;
  final num? basePriceFrom;

  ServiceApiModel({
    required this.id,
    required this.name,
    required this.slug,
    this.icon,
    this.basePriceFrom,
  });

  factory ServiceApiModel.fromJson(Map<String, dynamic> json) {
    return ServiceApiModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      icon: (json['icon']?.toString().trim().isEmpty ?? true) ? null : json['icon']?.toString(),
      basePriceFrom: json['basePriceFrom'] is num ? json['basePriceFrom'] as num : null,
    );
  }
}