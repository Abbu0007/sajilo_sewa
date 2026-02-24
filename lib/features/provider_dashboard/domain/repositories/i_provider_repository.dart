import 'package:sajilo_sewa/features/provider_dashboard/domain/entities/provider_notification_entity.dart';

import '../entities/provider_booking_entity.dart';
import '../entities/provider_me_entity.dart';
import '../entities/provider_profile_entity.dart';

abstract class IProviderRepository {
  Future<ProviderMeEntity> getMe();

  Future<ProviderProfileEntity?> getMyProviderProfile();
  Future<ProviderProfileEntity> updateMyProviderProfile({
    required String profession,
    String? bio,
    num? startingPrice,
    List<String>? serviceAreas,
    String? availability,
  });

  Future<List<ProviderBookingEntity>> getProviderBookings({String status = "all"});
  Future<ProviderBookingEntity> acceptBooking(String bookingId);
  Future<ProviderBookingEntity> rejectBooking(String bookingId, {String? reason});
  Future<ProviderBookingEntity> updateBookingStatus(
    String bookingId, {
    required String status,
    String? reason,
  });

  Future<ProviderMeEntity> uploadAvatar(String filePath);
  Future<List<ProviderNotificationEntity>> getNotifications();
  Future<void> markNotificationRead(String id);
  Future<void> createRating({
  required String bookingId,
  required int stars,
  String? comment,
  });
}