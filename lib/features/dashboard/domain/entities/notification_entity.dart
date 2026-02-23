class NotificationEntity {
  final String id;
  final String title;
  final String message;
  final String? createdAt;
  final bool isRead;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.isRead,
  });
}