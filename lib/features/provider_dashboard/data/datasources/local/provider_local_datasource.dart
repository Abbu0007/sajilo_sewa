import 'package:hive_flutter/hive_flutter.dart';
import 'package:sajilo_sewa/core/constants/hive_table_constants.dart';
import 'package:sajilo_sewa/features/provider_dashboard/data/models/provider_me_hive_model.dart';
import 'package:sajilo_sewa/features/provider_dashboard/data/models/provider_profile_hive_model.dart';
import 'package:sajilo_sewa/features/provider_dashboard/data/models/provider_booking_hive_model.dart';
import 'package:sajilo_sewa/features/provider_dashboard/data/models/provider_notification_hive_model.dart';

abstract class ProviderLocalDataSource {
  Future<void> cacheMe(ProviderMeHiveModel me);
  Future<ProviderMeHiveModel?> getCachedMe();

  Future<void> cacheProfile(ProviderProfileHiveModel profile);
  Future<ProviderProfileHiveModel?> getCachedProfile();

  Future<void> cacheBookings(
    List<ProviderBookingHiveModel> bookings, {
    bool replace = true,
  });
  Future<List<ProviderBookingHiveModel>> getCachedBookings({
    String status = 'all',
  });

  Future<void> cacheNotifications(
    List<ProviderNotificationHiveModel> notifications,
  );
  Future<List<ProviderNotificationHiveModel>> getCachedNotifications();

  Future<void> markCachedNotificationAsRead(String id);
}

class ProviderLocalDataSourceImpl implements ProviderLocalDataSource {
  static const _meKey = 'provider_me';
  static const _profileKey = 'provider_profile';

  Box<ProviderMeHiveModel> get _meBox =>
      Hive.box<ProviderMeHiveModel>(HiveTableConstants.providerMeBox);

  Box<ProviderProfileHiveModel> get _profileBox =>
      Hive.box<ProviderProfileHiveModel>(HiveTableConstants.providerProfileBox);

  Box<ProviderBookingHiveModel> get _bookingsBox =>
      Hive.box<ProviderBookingHiveModel>(HiveTableConstants.providerBookingsBox);

  Box<ProviderNotificationHiveModel> get _notificationsBox =>
      Hive.box<ProviderNotificationHiveModel>(
        HiveTableConstants.providerNotificationsBox,
      );

  @override
  Future<void> cacheMe(ProviderMeHiveModel me) async {
    await _meBox.put(_meKey, me);
  }

  @override
  Future<ProviderMeHiveModel?> getCachedMe() async {
    return _meBox.get(_meKey);
  }

  @override
  Future<void> cacheProfile(ProviderProfileHiveModel profile) async {
    await _profileBox.put(_profileKey, profile);
  }

  @override
  Future<ProviderProfileHiveModel?> getCachedProfile() async {
    return _profileBox.get(_profileKey);
  }

  @override
  Future<void> cacheBookings(
    List<ProviderBookingHiveModel> bookings, {
    bool replace = true,
  }) async {
    if (replace) {
      await _bookingsBox.clear();
    }

    for (final booking in bookings) {
      await _bookingsBox.put(booking.id, booking);
    }
  }

  @override
  Future<List<ProviderBookingHiveModel>> getCachedBookings({
    String status = 'all',
  }) async {
    final all = _bookingsBox.values.toList();

    if (status == 'all') return all;

    return all
        .where(
          (b) =>
              b.status.trim().toLowerCase() == status.trim().toLowerCase(),
        )
        .toList();
  }

  @override
  Future<void> cacheNotifications(
    List<ProviderNotificationHiveModel> notifications,
  ) async {
    await _notificationsBox.clear();

    for (final item in notifications) {
      await _notificationsBox.put(item.id, item);
    }
  }

  @override
  Future<List<ProviderNotificationHiveModel>> getCachedNotifications() async {
    return _notificationsBox.values.toList();
  }

  @override
  Future<void> markCachedNotificationAsRead(String id) async {
    final current = _notificationsBox.get(id);
    if (current == null) return;

    await _notificationsBox.put(
      id,
      ProviderNotificationHiveModel(
        id: current.id,
        type: current.type,
        title: current.title,
        message: current.message,
        createdAt: current.createdAt,
        isRead: true,
        bookingId: current.bookingId,
      ),
    );
  }
}