import 'package:sajilo_sewa/features/admin_dashboard/domain/entities/admin_service_entity.dart';

class AdminServiceApiModel {
  final String id;
  final String name;
  final String slug;
  final String? icon;
  final int basePriceFrom;
  final String status;

  AdminServiceApiModel({
    required this.id,
    required this.name,
    required this.slug,
    this.icon,
    required this.basePriceFrom,
    required this.status,
  });

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString()) ?? 0;
  }

  factory AdminServiceApiModel.fromJson(Map<String, dynamic> json) {
    return AdminServiceApiModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      icon: json['icon']?.toString(),
      basePriceFrom: _toInt(json['basePriceFrom']),
      status: (json['status'] ?? 'active').toString(),
    );
  }

  AdminServiceEntity toEntity() => AdminServiceEntity(
        id: id,
        name: name,
        slug: slug,
        icon: icon,
        basePriceFrom: basePriceFrom,
        status: status,
      );
}