class NotificationApiModel {
  final String id;
  final String? title;
  final String? message;
  final String? createdAt;
  final bool isRead;
  final String? type;
  final String? bookingId;
  final Map<String, dynamic> meta;

  NotificationApiModel({
    required this.id,
    this.title,
    this.message,
    this.createdAt,
    required this.isRead,
    this.type,
    this.bookingId,
    this.meta = const {},
  });

  factory NotificationApiModel.fromJson(Map<String, dynamic> json) {
    String? norm(String? v) {
      final s = (v ?? '').trim();
      return s.isEmpty ? null : s;
    }

    
    final dynamic isReadRaw = json['isRead'] ?? json['read'];

    Map<String, dynamic> readMeta(dynamic v) {
      if (v is Map) {
        return Map<String, dynamic>.from(v);
      }
      return {};
    }

    return NotificationApiModel(
      id: json['_id']?.toString() ?? '',
      title: norm(json['title']?.toString()),
      message: norm(json['message']?.toString()),
      createdAt: norm(json['createdAt']?.toString()),
      isRead: isReadRaw == true,

      
      type: norm(json['type']?.toString()),
      bookingId: norm(json['bookingId']?.toString()),
      meta: readMeta(json['meta']),
    );
  }
}