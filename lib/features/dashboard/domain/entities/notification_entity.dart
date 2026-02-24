class NotificationEntity {
  final String id;
  final String title;
  final String message;
  final String? createdAt;
  final bool isRead;
  final String? type;
  final String? bookingId;
  final Map<String, dynamic> meta;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.isRead,
    this.type,
    this.bookingId,
    this.meta = const {},
  });
}