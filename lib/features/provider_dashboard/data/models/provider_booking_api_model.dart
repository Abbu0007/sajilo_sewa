class ProviderBookingClientApiModel {
  final String id;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? email; 
  final String? avatarUrl;

  ProviderBookingClientApiModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.phone,
    this.email, 
    this.avatarUrl,
  });

  factory ProviderBookingClientApiModel.fromJson(Map<String, dynamic> json) {
    String? norm(String? v) {
      final s = (v ?? '').trim();
      return s.isEmpty ? null : s;
    }

    return ProviderBookingClientApiModel(
      id: json['_id']?.toString() ?? '',
      firstName: json['firstName']?.toString() ?? '',
      lastName: json['lastName']?.toString() ?? '',
      phone: norm(json['phone']?.toString()),
      email: norm(json['email']?.toString()), 
      avatarUrl: norm(json['avatarUrl']?.toString()),
    );
  }
}

class ProviderBookingServiceApiModel {
  final String id;
  final String name;
  final String? icon;
  final num? basePriceFrom;

  ProviderBookingServiceApiModel({
    required this.id,
    required this.name,
    this.icon,
    this.basePriceFrom,
  });

  factory ProviderBookingServiceApiModel.fromJson(Map<String, dynamic> json) {
    String? norm(String? v) {
      final s = (v ?? '').trim();
      return s.isEmpty ? null : s;
    }

    return ProviderBookingServiceApiModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      icon: norm(json['icon']?.toString()),
      basePriceFrom: (json['basePriceFrom'] is num) ? json['basePriceFrom'] as num : null,
    );
  }
}

class ProviderBookingApiModel {
  final String id;
  final String status;
  final String scheduledAt;
  final String? note;
  final String? addressText;
  final num? price;
  final String? paymentStatus;

  final ProviderBookingClientApiModel? client;
  final ProviderBookingServiceApiModel? service;

  ProviderBookingApiModel({
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

  factory ProviderBookingApiModel.fromJson(Map<String, dynamic> json) {
    String? norm(String? v) {
      final s = (v ?? '').trim();
      return s.isEmpty ? null : s;
    }

    final clientJson = json['clientId'];
    final serviceJson = json['serviceId'];

    return ProviderBookingApiModel(
      id: json['_id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      scheduledAt: json['scheduledAt']?.toString() ?? '',
      note: norm(json['note']?.toString()),
      addressText: norm(json['addressText']?.toString()),
      price: (json['price'] is num) ? json['price'] as num : null,
      paymentStatus: norm(json['paymentStatus']?.toString()),
      client: clientJson is Map
          ? ProviderBookingClientApiModel.fromJson(Map<String, dynamic>.from(clientJson))
          : null,
      service: serviceJson is Map
          ? ProviderBookingServiceApiModel.fromJson(Map<String, dynamic>.from(serviceJson))
          : null,
    );
  }
}