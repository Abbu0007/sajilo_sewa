import 'package:hive_flutter/hive_flutter.dart';
import 'package:sajilo_sewa/core/constants/hive_table_constants.dart';
import 'package:sajilo_sewa/features/dashboard/data/models/service_hive_model.dart';
import 'package:sajilo_sewa/features/dashboard/data/models/provider_hive_model.dart';
import 'package:sajilo_sewa/features/dashboard/data/models/booking_hive_model.dart';
import 'package:sajilo_sewa/features/dashboard/data/models/notification_hive_model.dart';
import 'package:sajilo_sewa/features/dashboard/data/models/profile_hive_model.dart';
import 'package:sajilo_sewa/features/dashboard/data/models/profile_stats_hive_model.dart';

abstract class DashboardLocalDataSource {
  Future<void> cacheServices(List<ServiceHiveModel> services);
  Future<List<ServiceHiveModel>> getCachedServices();
  Future<void> clearServices();

  Future<void> cacheTopRatedProviders(List<ProviderHiveModel> providers);
  Future<List<ProviderHiveModel>> getCachedTopRatedProviders({int? limit});

  Future<void> cacheProvidersByService(
    String serviceSlug,
    List<ProviderHiveModel> providers,
  );
  Future<List<ProviderHiveModel>> getCachedProvidersByService(String serviceSlug);

  Future<void> cacheFavourites(List<ProviderHiveModel> providers);
  Future<List<ProviderHiveModel>> getCachedFavourites();

  Future<void> cacheBookings(
    List<BookingHiveModel> bookings, {
    bool replace = true,
  });
  Future<List<BookingHiveModel>> getCachedBookings({String status = 'all'});

  Future<void> cacheNotifications(List<NotificationHiveModel> notifications);
  Future<List<NotificationHiveModel>> getCachedNotifications();

  Future<void> cacheProfile(ProfileHiveModel profile);
  Future<ProfileHiveModel?> getCachedProfile();

  Future<void> cacheProfileStats(ProfileStatsHiveModel stats);
  Future<ProfileStatsHiveModel?> getCachedProfileStats();

  Future<void> markCachedNotificationAsRead(String id);
}

class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  static const _topRatedPrefix = 'top_rated__';
  static const _servicePrefix = 'service__';
  static const _favouritesPrefix = 'favourite__';
  static const _profileKey = 'me';
  static const _profileStatsKey = 'client_profile_stats';

  Box<ServiceHiveModel> get _servicesBox =>
      Hive.box<ServiceHiveModel>(HiveTableConstants.servicesBox);

  Box<ProviderHiveModel> get _providersBox =>
      Hive.box<ProviderHiveModel>(HiveTableConstants.providersBox);

  Box<BookingHiveModel> get _bookingsBox =>
      Hive.box<BookingHiveModel>(HiveTableConstants.bookingsBox);

  Box<NotificationHiveModel> get _notificationsBox =>
      Hive.box<NotificationHiveModel>(HiveTableConstants.notificationsBox);

  Box<ProfileHiveModel> get _profileBox =>
      Hive.box<ProfileHiveModel>(HiveTableConstants.profileBox);

  Box<ProfileStatsHiveModel> get _profileStatsBox =>
      Hive.box<ProfileStatsHiveModel>(HiveTableConstants.profileStatsBox);

  @override
  Future<void> cacheServices(List<ServiceHiveModel> services) async {
    await _servicesBox.clear();
    for (final service in services) {
      await _servicesBox.put(service.slug, service);
    }
  }

  @override
  Future<List<ServiceHiveModel>> getCachedServices() async {
    return _servicesBox.values.toList();
  }

  @override
  Future<void> clearServices() async {
    await _servicesBox.clear();
  }

  @override
  Future<void> cacheTopRatedProviders(List<ProviderHiveModel> providers) async {
    await _clearProvidersByPrefix(_topRatedPrefix);
    for (final provider in providers) {
      await _providersBox.put('$_topRatedPrefix${provider.id}', provider);
    }
  }

  @override
  Future<List<ProviderHiveModel>> getCachedTopRatedProviders({int? limit}) async {
    final items = _providersBox.toMap().entries
        .where((e) => e.key.toString().startsWith(_topRatedPrefix))
        .map((e) => e.value)
        .toList();

    if (limit == null) return items;
    return items.take(limit).toList();
  }

  @override
  Future<void> cacheProvidersByService(
    String serviceSlug,
    List<ProviderHiveModel> providers,
  ) async {
    final prefix = '$_servicePrefix${serviceSlug}__';
    await _clearProvidersByPrefix(prefix);

    for (final provider in providers) {
      await _providersBox.put('$prefix${provider.id}', provider);
    }
  }

  @override
  Future<List<ProviderHiveModel>> getCachedProvidersByService(
    String serviceSlug,
  ) async {
    final prefix = '$_servicePrefix${serviceSlug}__';
    return _providersBox.toMap().entries
        .where((e) => e.key.toString().startsWith(prefix))
        .map((e) => e.value)
        .toList();
  }

  @override
  Future<void> cacheFavourites(List<ProviderHiveModel> providers) async {
    await _clearProvidersByPrefix(_favouritesPrefix);

    for (final provider in providers) {
      await _providersBox.put('$_favouritesPrefix${provider.id}', provider);
    }
  }

  @override
  Future<List<ProviderHiveModel>> getCachedFavourites() async {
    return _providersBox.toMap().entries
        .where((e) => e.key.toString().startsWith(_favouritesPrefix))
        .map((e) => e.value)
        .toList();
  }

  @override
  Future<void> cacheBookings(
    List<BookingHiveModel> bookings, {
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
  Future<List<BookingHiveModel>> getCachedBookings({String status = 'all'}) async {
    final all = _bookingsBox.values.toList();

    if (status == 'all') return all;

    return all
        .where((b) => b.status.trim().toLowerCase() == status.trim().toLowerCase())
        .toList();
  }

  @override
  Future<void> cacheNotifications(
    List<NotificationHiveModel> notifications,
  ) async {
    await _notificationsBox.clear();

    for (final item in notifications) {
      await _notificationsBox.put(item.id, item);
    }
  }

  @override
  Future<List<NotificationHiveModel>> getCachedNotifications() async {
    return _notificationsBox.values.toList();
  }

  @override
  Future<void> markCachedNotificationAsRead(String id) async {
    final current = _notificationsBox.get(id);
    if (current == null) return;

    await _notificationsBox.put(
      id,
      NotificationHiveModel(
        id: current.id,
        title: current.title,
        message: current.message,
        createdAt: current.createdAt,
        isRead: true,
        type: current.type,
        bookingId: current.bookingId,
        metaJson: current.metaJson,
      ),
    );
  }

  @override
  Future<void> cacheProfile(ProfileHiveModel profile) async {
    await _profileBox.put(_profileKey, profile);
  }

  @override
  Future<ProfileHiveModel?> getCachedProfile() async {
    return _profileBox.get(_profileKey);
  }

  @override
  Future<void> cacheProfileStats(ProfileStatsHiveModel stats) async {
    await _profileStatsBox.put(_profileStatsKey, stats);
  }

  @override
  Future<ProfileStatsHiveModel?> getCachedProfileStats() async {
    return _profileStatsBox.get(_profileStatsKey);
  }

  Future<void> _clearProvidersByPrefix(String prefix) async {
    final keys = _providersBox.keys
        .where((k) => k.toString().startsWith(prefix))
        .toList();

    await _providersBox.deleteAll(keys);
  }
}