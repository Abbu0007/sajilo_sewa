class ProviderNotificationApiModel {
  final String id;
  final String? type;        
  final String? title;
  final String? message;
  final String? createdAt;
  final bool isRead;
  final String? bookingId;   

  ProviderNotificationApiModel({
    required this.id,
    this.type,
    this.title,
    this.message,
    this.createdAt,
    required this.isRead,
    this.bookingId,
  });

  factory ProviderNotificationApiModel.fromJson(Map<String, dynamic> json) {
    String? norm(String? v) {
      final s = (v ?? '').trim();
      return s.isEmpty ? null : s;
    }

    final dynamic isReadRaw = json['isRead'] ?? json['read'];

    
    String? parseBookingId(dynamic v) {
      if (v == null) return null;
      if (v is String) return v;
      if (v is Map && v['_id'] != null) return v['_id'].toString();
      return null;
    }

    return ProviderNotificationApiModel(
      id: json['_id']?.toString() ?? '',
      type: norm(json['type']?.toString()),
      title: norm(json['title']?.toString()),
      message: norm(json['message']?.toString()),
      createdAt: norm(json['createdAt']?.toString()),
      isRead: isReadRaw == true,
      bookingId: parseBookingId(json['bookingId']),
    );
  }
}