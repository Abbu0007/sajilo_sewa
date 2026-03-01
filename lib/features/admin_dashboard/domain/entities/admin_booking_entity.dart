class AdminMiniUserEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String avatarUrl;

  final double ratingAvg;
  final int ratingCount;
  final int completedBookings;

  const AdminMiniUserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.avatarUrl,
    required this.ratingAvg,
    required this.ratingCount,
    required this.completedBookings,
  });

  String get fullName => ('$firstName $lastName').trim();
}

class AdminMiniServiceEntity {
  final String id;
  final String name;
  final String? slug;
  final String? imageUrl;

  const AdminMiniServiceEntity({
    required this.id,
    required this.name,
    this.slug,
    this.imageUrl,
  });
}

class AdminBookingEntity {
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

  const AdminBookingEntity({
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

  bool get canCancel {
    final s = status.toLowerCase();
    return s != 'completed' && s != 'cancelled' && s != 'rejected';
  }

  bool get canDelete => true;
}