import 'provider_api_model.dart';
import 'service_api_model.dart';

class BookingApiModel {
  final String id;
  final String status;
  final String scheduledAt;
  final String? note;
  final String? addressText;
  final num? price;
  final String? paymentStatus;

  // populated objects
  final ProviderApiModel? provider;
  final ServiceApiModel? service;

  BookingApiModel({
    required this.id,
    required this.status,
    required this.scheduledAt,
    this.note,
    this.addressText,
    this.price,
    this.paymentStatus,
    this.provider,
    this.service,
  });

  factory BookingApiModel.fromJson(Map<String, dynamic> json) {
    String? normalize(String? v) {
      final s = (v ?? '').trim();
      return s.isEmpty ? null : s;
    }

    final providerJson = json['providerId'];
    final serviceJson = json['serviceId'];

    return BookingApiModel(
      id: json['_id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      scheduledAt: json['scheduledAt']?.toString() ?? '',
      note: normalize(json['note']?.toString()),
      addressText: normalize(json['addressText']?.toString()),
      price: json['price'] is num ? json['price'] as num : null,
      paymentStatus: normalize(json['paymentStatus']?.toString()),
      provider: providerJson is Map<String, dynamic> ? ProviderApiModel.fromJson(providerJson) : null,
      service: serviceJson is Map<String, dynamic> ? ServiceApiModel.fromJson(serviceJson) : null,
    );
  }
}