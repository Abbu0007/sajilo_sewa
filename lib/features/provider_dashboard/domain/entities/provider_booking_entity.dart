class ProviderBookingClientEntity {
  final String id;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? email; 
  final String? avatarUrl;

  const ProviderBookingClientEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.email, 
    this.avatarUrl,
  });

  String get fullName => ('$firstName $lastName').trim();
}

class ProviderBookingServiceEntity {
  final String id;
  final String name;
  final String? icon;
  final num? basePriceFrom;

  const ProviderBookingServiceEntity({
    required this.id,
    required this.name,
    this.icon,
    this.basePriceFrom,
  });
}

class ProviderBookingEntity {
  final String id;
  final String status;
  final String scheduledAt;
  final String? note;
  final String? addressText;
  final num? price;
  final String? paymentStatus;

  final ProviderBookingClientEntity? client;
  final ProviderBookingServiceEntity? service;

  const ProviderBookingEntity({
    required this.id,
    required this.status,
    required this.scheduledAt,
    this.note,
    this.addressText,
    this.price,
    this.paymentStatus,
    this.client,
    this.service,
  });
}


extension ProviderBookingPretty on ProviderBookingEntity {
  DateTime? get scheduledAtDate {
    try {
      return DateTime.parse(scheduledAt).toLocal();
    } catch (_) {
      return null;
    }
  }

  String get prettyDateTime {
    final d = scheduledAtDate;
    if (d == null) return scheduledAt;

    String two(int n) => n.toString().padLeft(2, '0');

    final y = d.year;
    final m = two(d.month);
    final day = two(d.day);

    final hour12 = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final ampm = d.hour >= 12 ? "PM" : "AM";
    final hh = two(hour12);
    final mm = two(d.minute);

    return "$y-$m-$day • $hh:$mm $ampm";
  }
}