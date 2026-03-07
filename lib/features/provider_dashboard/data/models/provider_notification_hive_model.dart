import 'package:hive/hive.dart';

part 'provider_notification_hive_model.g.dart';

@HiveType(typeId: 11)
class ProviderNotificationHiveModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String? type;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String message;

  @HiveField(4)
  final String? createdAt;

  @HiveField(5)
  final bool isRead;

  @HiveField(6)
  final String? bookingId;

  const ProviderNotificationHiveModel({
    required this.id,
    this.type,
    required this.title,
    required this.message,
    this.createdAt,
    required this.isRead,
    this.bookingId,
  });
}