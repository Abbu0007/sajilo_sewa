class ProviderNotificationEntity {
  final String id;
  final String? type;        
  final String title;
  final String message;
  final String? createdAt;
  final bool isRead;
  final String? bookingId;   

  const ProviderNotificationEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.isRead,
    required this.bookingId,
  });

  bool get isRatingRequest =>
      (type ?? '').trim().toLowerCase() == 'rating_request';
}