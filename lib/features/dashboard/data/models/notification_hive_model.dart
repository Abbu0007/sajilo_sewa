import 'package:hive/hive.dart';

part 'notification_hive_model.g.dart';

@HiveType(typeId: 5)
class NotificationHiveModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String message;

  @HiveField(3)
  final String? createdAt;

  @HiveField(4)
  final bool isRead;

  @HiveField(5)
  final String? type;

  @HiveField(6)
  final String? bookingId;

  @HiveField(7)
  final String metaJson;

  const NotificationHiveModel({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.isRead,
    this.type,
    this.bookingId,
    required this.metaJson,
  });
}