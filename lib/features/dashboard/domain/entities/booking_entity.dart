import 'provider_entity.dart';
import 'service_entity.dart';

class BookingEntity {
  final String id;
  final String status;
  final String scheduledAt;
  final String? note;
  final String? addressText;
  final num? price;
  final String? paymentStatus;

  final ProviderEntity? provider;
  final ServiceEntity? service;

  const BookingEntity({
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
}