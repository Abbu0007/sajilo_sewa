class NotificationApiModel {
  final String id;
  final String? title;
  final String? message;
  final String? createdAt;
  final bool isRead;

  NotificationApiModel({
    required this.id,
    this.title,
    this.message,
    this.createdAt,
    required this.isRead,
  });

  factory NotificationApiModel.fromJson(Map<String, dynamic> json) {
    String? norm(String? v) {
      final s = (v ?? '').trim();
      return s.isEmpty ? null : s;
    }

    // backend might return isRead OR read
    final dynamic isReadRaw = json['isRead'] ?? json['read'];

    return NotificationApiModel(
      id: json['_id']?.toString() ?? '',
      title: norm(json['title']?.toString()),
      message: norm(json['message']?.toString()),
      createdAt: norm(json['createdAt']?.toString()),
      isRead: isReadRaw == true,
    );
  }
}