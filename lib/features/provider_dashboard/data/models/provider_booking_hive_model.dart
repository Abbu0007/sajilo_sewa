import 'package:hive/hive.dart';

part 'provider_booking_hive_model.g.dart';

@HiveType(typeId: 10)
class ProviderBookingHiveModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String status;

  @HiveField(2)
  final String scheduledAt;

  @HiveField(3)
  final String? note;

  @HiveField(4)
  final String? addressText;

  @HiveField(5)
  final double? price;

  @HiveField(6)
  final String? paymentStatus;

  @HiveField(7)
  final String? clientId;

  @HiveField(8)
  final String? clientFirstName;

  @HiveField(9)
  final String? clientLastName;

  @HiveField(10)
  final String? clientPhone;

  @HiveField(11)
  final String? clientEmail;

  @HiveField(12)
  final String? clientAvatarUrl;

  @HiveField(13)
  final String? serviceId;

  @HiveField(14)
  final String? serviceName;

  @HiveField(15)
  final String? serviceIcon;

  @HiveField(16)
  final double? serviceBasePriceFrom;

  const ProviderBookingHiveModel({
    required this.id,
    required this.status,
    required this.scheduledAt,
    this.note,
    this.addressText,
    this.price,
    this.paymentStatus,
    this.clientId,
    this.clientFirstName,
    this.clientLastName,
    this.clientPhone,
    this.clientEmail,
    this.clientAvatarUrl,
    this.serviceId,
    this.serviceName,
    this.serviceIcon,
    this.serviceBasePriceFrom,
  });
}