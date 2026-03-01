import 'package:sajilo_sewa/core/utils/url_utils.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/entities/admin_booking_entity.dart';

class AdminBookingApiModel {
  final String id;
  final String status;
  final DateTime? scheduledAt;
  final String note;
  final String addressText;
  final double price;
  final String paymentStatus;

  final AdminMiniServiceEntity? service;
  final AdminMiniUserEntity? client;
  final AdminMiniUserEntity? provider;

  AdminBookingApiModel({
    required this.id,
    required this.status,
    required this.scheduledAt,
    required this.note,
    required this.addressText,
    required this.price,
    required this.paymentStatus,
    required this.service,
    required this.client,
    required this.provider,
  });

  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }

  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString()) ?? 0;
  }

  static DateTime? _toDate(dynamic v) {
    if (v == null) return null;
    try {
      final s = v.toString();
      if (s.trim().isEmpty) return null;
      return DateTime.parse(s).toLocal();
    } catch (_) {
      return null;
    }
  }

  static AdminMiniUserEntity? _parseUser(dynamic json) {
    if (json is! Map<String, dynamic>) return null;

    final rawAvatar = (json['avatarUrl'] ?? '').toString();
    final avatar = rawAvatar.isEmpty ? '' : UrlUtils.normalizeMediaUrl(rawAvatar);

    return AdminMiniUserEntity(
      id: (json['id'] ?? '').toString(),
      firstName: (json['firstName'] ?? '').toString(),
      lastName: (json['lastName'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      avatarUrl: avatar,
      ratingAvg: _toDouble(json['ratingAvg']),
      ratingCount: _toInt(json['ratingCount']),
      completedBookings: _toInt(json['completedBookings']),
    );
  }

  static AdminMiniServiceEntity? _parseService(dynamic json) {
    if (json is! Map<String, dynamic>) return null;
    final rawImg = (json['imageUrl'] ?? '').toString();
    final img = rawImg.isEmpty ? null : UrlUtils.normalizeMediaUrl(rawImg);

    return AdminMiniServiceEntity(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? 'Service').toString(),
      slug: json['slug']?.toString(),
      imageUrl: img,
    );
  }

  factory AdminBookingApiModel.fromJson(Map<String, dynamic> json) {
    return AdminBookingApiModel(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      scheduledAt: _toDate(json['scheduledAt']),
      note: (json['note'] ?? '').toString(),
      addressText: (json['addressText'] ?? '').toString(),
      price: _toDouble(json['price']),
      paymentStatus: (json['paymentStatus'] ?? 'unpaid').toString(),
      service: _parseService(json['service']),
      client: _parseUser(json['client']),
      provider: _parseUser(json['provider']),
    );
  }

  AdminBookingEntity toEntity() => AdminBookingEntity(
        id: id,
        status: status,
        scheduledAt: scheduledAt,
        note: note,
        addressText: addressText,
        price: price,
        paymentStatus: paymentStatus,
        service: service,
        client: client,
        provider: provider,
      );
}

class AdminBookingListResponse {
  final List<AdminBookingApiModel> items;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  AdminBookingListResponse({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  static int _toInt(dynamic v, int fallback) {
    if (v == null) return fallback;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString()) ?? fallback;
  }

  factory AdminBookingListResponse.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List?) ?? const [];
    return AdminBookingListResponse(
      items: rawItems
          .whereType<Map>()
          .map((e) => AdminBookingApiModel.fromJson(e.cast<String, dynamic>()))
          .toList(),
      page: _toInt(json['page'], 1),
      limit: _toInt(json['limit'], 20),
      total: _toInt(json['total'], 0),
      totalPages: _toInt(json['totalPages'], 1),
    );
  }
}