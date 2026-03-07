import 'package:hive/hive.dart';

part 'booking_hive_model.g.dart';

@HiveType(typeId: 4)
class BookingHiveModel {
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
  final String? providerId;

  @HiveField(8)
  final String? providerFirstName;

  @HiveField(9)
  final String? providerLastName;

  @HiveField(10)
  final String? providerEmail;

  @HiveField(11)
  final String? providerPhone;

  @HiveField(12)
  final String? providerProfession;

  @HiveField(13)
  final String? providerServiceSlug;

  @HiveField(14)
  final String? providerAvatarUrl;

  @HiveField(15)
  final double? providerAvgRating;

  @HiveField(16)
  final int? providerRatingCount;

  @HiveField(17)
  final int? providerCompletedJobs;

  @HiveField(18)
  final int? providerStartingPrice;

  @HiveField(19)
  final String? serviceId;

  @HiveField(20)
  final String? serviceName;

  @HiveField(21)
  final String? serviceSlug;

  @HiveField(22)
  final String? serviceIcon;

  @HiveField(23)
  final double? serviceBasePriceFrom;

  const BookingHiveModel({
    required this.id,
    required this.status,
    required this.scheduledAt,
    this.note,
    this.addressText,
    this.price,
    this.paymentStatus,
    this.providerId,
    this.providerFirstName,
    this.providerLastName,
    this.providerEmail,
    this.providerPhone,
    this.providerProfession,
    this.providerServiceSlug,
    this.providerAvatarUrl,
    this.providerAvgRating,
    this.providerRatingCount,
    this.providerCompletedJobs,
    this.providerStartingPrice,
    this.serviceId,
    this.serviceName,
    this.serviceSlug,
    this.serviceIcon,
    this.serviceBasePriceFrom,
  });
}