import 'dart:convert';
import 'package:sajilo_sewa/features/dashboard/data/datasources/local/dashboard_local_datasource.dart';
import 'package:sajilo_sewa/features/dashboard/data/datasources/remote/dashboard_remote_datasource.dart';
import 'package:sajilo_sewa/features/dashboard/data/models/service_hive_model.dart';
import 'package:sajilo_sewa/features/dashboard/data/models/provider_api_model.dart';
import 'package:sajilo_sewa/features/dashboard/data/models/provider_hive_model.dart';
import 'package:sajilo_sewa/features/dashboard/data/models/booking_api_model.dart';
import 'package:sajilo_sewa/features/dashboard/data/models/booking_hive_model.dart';
import 'package:sajilo_sewa/features/dashboard/data/models/notification_hive_model.dart';
import 'package:sajilo_sewa/features/dashboard/domain/entities/booking_entity.dart';
import 'package:sajilo_sewa/features/dashboard/domain/entities/notification_entity.dart';
import 'package:sajilo_sewa/features/dashboard/domain/entities/provider_entity.dart';
import 'package:sajilo_sewa/features/dashboard/domain/entities/service_entity.dart';
import 'package:sajilo_sewa/features/dashboard/domain/repositories/i_dashboard_repository.dart';



class DashboardRepositoryImpl implements IDashboardRepository {
  final DashboardRemoteDataSource remote;
  final DashboardLocalDataSource local;

  DashboardRepositoryImpl({
    required this.remote,
    required this.local,
  });

  @override
  Future<List<ServiceEntity>> getServices() async {
    try {
      final models = await remote.getServices();

      final hiveModels = models
          .map(
            (m) => ServiceHiveModel(
              id: m.id,
              name: m.name,
              slug: m.slug,
              icon: m.icon,
              basePriceFrom: m.basePriceFrom,
            ),
          )
          .toList();

      await local.cacheServices(hiveModels);

      return models.map(_serviceApiToEntity).toList();
    } catch (_) {
      final cached = await local.getCachedServices();
      return cached.map(_serviceHiveToEntity).toList();
    }
  }

  @override
  Future<List<ProviderEntity>> getTopRatedProviders({int limit = 8}) async {
    try {
      final models = await remote.getTopRatedProviders(limit: limit);
      await local.cacheTopRatedProviders(models.map(_providerApiToHive).toList());
      return models.map(_providerApiToEntity).toList();
    } catch (_) {
      final cached = await local.getCachedTopRatedProviders(limit: limit);
      return cached.map(_providerHiveToEntity).toList();
    }
  }

  @override
  Future<List<ProviderEntity>> getProvidersByService(String slug) async {
    try {
      final models = await remote.getProvidersByService(slug);
      await local.cacheProvidersByService(
        slug,
        models.map(_providerApiToHive).toList(),
      );
      return models.map(_providerApiToEntity).toList();
    } catch (_) {
      final cached = await local.getCachedProvidersByService(slug);
      return cached.map(_providerHiveToEntity).toList();
    }
  }

  @override
  Future<List<ProviderEntity>> getFavourites() async {
    try {
      final models = await remote.getFavourites();
      await local.cacheFavourites(models.map(_providerApiToHive).toList());
      return models.map(_providerApiToEntity).toList();
    } catch (_) {
      final cached = await local.getCachedFavourites();
      return cached.map(_providerHiveToEntity).toList();
    }
  }

  @override
  Future<bool> toggleFavourite(String providerId) {
    return remote.toggleFavourite(providerId);
  }

  @override
  Future<List<BookingEntity>> getMyBookings({String status = "all"}) async {
    try {
      final models = await remote.getMyBookings(status: status);

      await local.cacheBookings(
        models.map(_bookingApiToHive).toList(),
        replace: status == 'all',
      );

      return models.map(_bookingApiToEntity).toList();
    } catch (_) {
      final cached = await local.getCachedBookings(status: status);
      return cached.map(_bookingHiveToEntity).toList();
    }
  }

  @override
  Future<BookingEntity> createBooking({
    required String providerId,
    required String serviceId,
    required String scheduledAt,
    String? addressText,
    String? note,
  }) async {
    final model = await remote.createBooking(
      providerId: providerId,
      serviceId: serviceId,
      scheduledAt: scheduledAt,
      addressText: addressText,
      note: note,
    );

    await local.cacheBookings([_bookingApiToHive(model)], replace: false);

    return _bookingApiToEntity(model);
  }

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    try {
      final models = await remote.getNotifications();

      await local.cacheNotifications(
        models
            .map(
              (m) => NotificationHiveModel(
                id: m.id,
                title: m.title ?? 'Notification',
                message: m.message ?? '',
                createdAt: m.createdAt,
                isRead: m.isRead,
                type: m.type,
                bookingId: m.bookingId,
                metaJson: jsonEncode(m.meta),
              ),
            )
            .toList(),
      );

      return models
          .map(
            (m) => NotificationEntity(
              id: m.id,
              title: m.title ?? "Notification",
              message: m.message ?? "",
              createdAt: m.createdAt,
              isRead: m.isRead,
              type: m.type,
              bookingId: m.bookingId,
              meta: m.meta,
            ),
          )
          .toList();
    } catch (_) {
      final cached = await local.getCachedNotifications();

      return cached
          .map(
            (m) => NotificationEntity(
              id: m.id,
              title: m.title,
              message: m.message,
              createdAt: m.createdAt,
              isRead: m.isRead,
              type: m.type,
              bookingId: m.bookingId,
              meta: _decodeMeta(m.metaJson),
            ),
          )
          .toList();
    }
  }

  @override
  Future<void> createRating({
    required String bookingId,
    required int stars,
    String? comment,
  }) {
    return remote.createRating(
      bookingId: bookingId,
      stars: stars,
      comment: comment,
    );
  }

  @override
  Future<void> markNotificationRead(String id) async {
    await remote.markNotificationRead(id);
    await local.markCachedNotificationAsRead(id);
  }

  @override
  Future<void> cancelBooking(String bookingId, {String? reason}) {
    return remote.cancelBooking(bookingId, reason: reason);
  }

  @override
  Future<void> confirmPayment(String bookingId) {
    return remote.confirmPayment(bookingId);
  }

  ServiceEntity _serviceApiToEntity(dynamic m) {
    return ServiceEntity(
      id: m.id,
      name: m.name,
      slug: m.slug,
      icon: m.icon,
      basePriceFrom: m.basePriceFrom,
    );
  }

  ServiceEntity _serviceHiveToEntity(ServiceHiveModel m) {
    return ServiceEntity(
      id: m.id,
      name: m.name,
      slug: m.slug,
      icon: m.icon,
      basePriceFrom: m.basePriceFrom,
    );
  }

  ProviderEntity _providerApiToEntity(ProviderApiModel m) {
    return ProviderEntity(
      id: m.id,
      firstName: m.firstName,
      lastName: m.lastName,
      phone: m.phone,
      email: m.email,
      profession: m.profession,
      serviceSlug: m.serviceSlug,
      avatarUrl: m.avatarUrl,
      avgRating: m.avgRating,
      ratingCount: m.ratingCount,
      completedJobs: m.completedJobs,
      startingPrice: m.startingPrice,
    );
  }

  ProviderHiveModel _providerApiToHive(ProviderApiModel m) {
    return ProviderHiveModel(
      id: m.id,
      firstName: m.firstName,
      lastName: m.lastName,
      email: m.email,
      phone: m.phone,
      profession: m.profession,
      serviceSlug: m.serviceSlug,
      avatarUrl: m.avatarUrl,
      avgRating: m.avgRating,
      ratingCount: m.ratingCount,
      completedJobs: m.completedJobs,
      startingPrice: m.startingPrice,
    );
  }

  ProviderEntity _providerHiveToEntity(ProviderHiveModel m) {
    return ProviderEntity(
      id: m.id,
      firstName: m.firstName,
      lastName: m.lastName,
      email: m.email,
      phone: m.phone,
      profession: m.profession,
      serviceSlug: m.serviceSlug,
      avatarUrl: m.avatarUrl,
      avgRating: m.avgRating,
      ratingCount: m.ratingCount,
      completedJobs: m.completedJobs,
      startingPrice: m.startingPrice,
    );
  }

  BookingHiveModel _bookingApiToHive(BookingApiModel m) {
    return BookingHiveModel(
      id: m.id,
      status: m.status,
      scheduledAt: m.scheduledAt,
      note: m.note,
      addressText: m.addressText,
      price: m.price?.toDouble(),
      paymentStatus: m.paymentStatus,
      providerId: m.provider?.id,
      providerFirstName: m.provider?.firstName,
      providerLastName: m.provider?.lastName,
      providerEmail: m.provider?.email,
      providerPhone: m.provider?.phone,
      providerProfession: m.provider?.profession,
      providerServiceSlug: m.provider?.serviceSlug,
      providerAvatarUrl: m.provider?.avatarUrl,
      providerAvgRating: m.provider?.avgRating,
      providerRatingCount: m.provider?.ratingCount,
      providerCompletedJobs: m.provider?.completedJobs,
      providerStartingPrice: m.provider?.startingPrice,
      serviceId: m.service?.id,
      serviceName: m.service?.name,
      serviceSlug: m.service?.slug,
      serviceIcon: m.service?.icon,
      serviceBasePriceFrom: m.service?.basePriceFrom?.toDouble(),
    );
  }

  BookingEntity _bookingApiToEntity(BookingApiModel m) {
    return BookingEntity(
      id: m.id,
      status: m.status,
      scheduledAt: m.scheduledAt,
      note: m.note,
      addressText: m.addressText,
      price: m.price,
      paymentStatus: m.paymentStatus,
      provider: m.provider == null ? null : _providerApiToEntity(m.provider!),
      service: m.service == null
          ? null
          : ServiceEntity(
              id: m.service!.id,
              name: m.service!.name,
              slug: m.service!.slug,
              icon: m.service!.icon,
              basePriceFrom: m.service!.basePriceFrom,
            ),
    );
  }

  BookingEntity _bookingHiveToEntity(BookingHiveModel m) {
    return BookingEntity(
      id: m.id,
      status: m.status,
      scheduledAt: m.scheduledAt,
      note: m.note,
      addressText: m.addressText,
      price: m.price,
      paymentStatus: m.paymentStatus,
      provider: m.providerId == null
          ? null
          : ProviderEntity(
              id: m.providerId ?? '',
              firstName: m.providerFirstName ?? '',
              lastName: m.providerLastName ?? '',
              email: m.providerEmail ?? '',
              phone: m.providerPhone ?? '',
              profession: m.providerProfession ?? '',
              serviceSlug: m.providerServiceSlug ?? '',
              avatarUrl: m.providerAvatarUrl,
              avgRating: m.providerAvgRating ?? 0,
              ratingCount: m.providerRatingCount ?? 0,
              completedJobs: m.providerCompletedJobs ?? 0,
              startingPrice: m.providerStartingPrice ?? 0,
            ),
      service: m.serviceId == null
          ? null
          : ServiceEntity(
              id: m.serviceId ?? '',
              name: m.serviceName ?? '',
              slug: m.serviceSlug ?? '',
              icon: m.serviceIcon,
              basePriceFrom: m.serviceBasePriceFrom,
            ),
    );
  }

  Map<String, dynamic> _decodeMeta(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
      return {};
    } catch (_) {
      return {};
    }
  }
}