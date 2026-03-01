import 'package:sajilo_sewa/features/dashboard/domain/entities/notification_entity.dart';

import '../entities/booking_entity.dart';
import '../entities/provider_entity.dart';
import '../entities/service_entity.dart';

abstract class IDashboardRepository {
  Future<List<ServiceEntity>> getServices();
  Future<List<ProviderEntity>> getTopRatedProviders({int limit = 8});
  Future<List<ProviderEntity>> getProvidersByService(String slug);

  Future<List<ProviderEntity>> getFavourites();
  Future<bool> toggleFavourite(String providerId);

  Future<List<NotificationEntity>> getNotifications();
  Future<void> markNotificationRead(String id);

  Future<void> cancelBooking(String bookingId, {String? reason});
  Future<void> confirmPayment(String bookingId);

  Future<void> createRating({
  required String bookingId,
  required int stars,
  String? comment,
  });

  Future<List<BookingEntity>> getMyBookings({String status = "all"});
  Future<BookingEntity> createBooking({
    required String providerId,
    required String serviceId,
    required String scheduledAt,
    String? addressText,
    String? note,
  });
}