import 'package:sajilo_sewa/features/dashboard/data/datasources/remote/dashboard_remote_datasource.dart';
import 'package:sajilo_sewa/features/dashboard/domain/entities/notification_entity.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/entities/provider_entity.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/repositories/i_dashboard_repository.dart';

class DashboardRepositoryImpl implements IDashboardRepository {
  final DashboardRemoteDataSource remote;

  DashboardRepositoryImpl({required this.remote});

  @override
  Future<List<ServiceEntity>> getServices() async {
    final models = await remote.getServices();
    return models
        .map((m) => ServiceEntity(
              id: m.id,
              name: m.name,
              slug: m.slug,
              icon: m.icon,
              basePriceFrom: m.basePriceFrom,
            ))
        .toList();
  }

  @override
  Future<List<ProviderEntity>> getTopRatedProviders({int limit = 8}) async {
    final models = await remote.getTopRatedProviders(limit: limit);
    return models
        .map((m) => ProviderEntity(
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
            ))
        .toList();
  }

  @override
  Future<List<ProviderEntity>> getProvidersByService(String slug) async {
    final models = await remote.getProvidersByService(slug);
    return models
        .map((m) => ProviderEntity(
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
            ))
        .toList();
  }

  @override
  Future<List<ProviderEntity>> getFavourites() async {
    final models = await remote.getFavourites();
    return models
        .map((m) => ProviderEntity(
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
            ))
        .toList();
  }

  @override
  Future<bool> toggleFavourite(String providerId) {
    return remote.toggleFavourite(providerId);
  }

  @override
  Future<List<BookingEntity>> getMyBookings({String status = "all"}) async {
    final models = await remote.getMyBookings(status: status);

    return models.map((m) {
      return BookingEntity(
        id: m.id,
        status: m.status,
        scheduledAt: m.scheduledAt,
        note: m.note,
        addressText: m.addressText,
        price: m.price,
        paymentStatus: m.paymentStatus,
        provider: m.provider == null
            ? null
            : ProviderEntity(
                id: m.provider!.id,
                firstName: m.provider!.firstName,
                lastName: m.provider!.lastName,
                phone: m.provider!.phone,
                email: m.provider!.email,
                profession: m.provider!.profession,
                serviceSlug: m.provider!.serviceSlug,
                avatarUrl: m.provider!.avatarUrl,
                avgRating: m.provider!.avgRating,
                ratingCount: m.provider!.ratingCount,
                completedJobs: m.provider!.completedJobs,
                startingPrice: m.provider!.startingPrice,
              ),
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
    }).toList();
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

    return BookingEntity(
      id: model.id,
      status: model.status,
      scheduledAt: model.scheduledAt,
      note: model.note,
      addressText: model.addressText,
      price: model.price,
      paymentStatus: model.paymentStatus,
      provider: model.provider == null
          ? null
          : ProviderEntity(
              id: model.provider!.id,
              firstName: model.provider!.firstName,
              lastName: model.provider!.lastName,
              phone: model.provider!.phone,
              email: model.provider!.email,
              profession: model.provider!.profession,
              serviceSlug: model.provider!.serviceSlug,
              avatarUrl: model.provider!.avatarUrl,
              avgRating: model.provider!.avgRating,
              ratingCount: model.provider!.ratingCount,
              completedJobs: model.provider!.completedJobs,
              startingPrice: model.provider!.startingPrice,
            ),
      service: model.service == null
          ? null
          : ServiceEntity(
              id: model.service!.id,
              name: model.service!.name,
              slug: model.service!.slug,
              icon: model.service!.icon,
              basePriceFrom: model.service!.basePriceFrom,
            ),
    );
  }

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    final models = await remote.getNotifications();
    return models
        .map((m) => NotificationEntity(
              id: m.id,
              title: m.title ?? "Notification",
              message: m.message ?? "",
              createdAt: m.createdAt,
              isRead: m.isRead,
              type: m.type,
              bookingId: m.bookingId,
              meta: m.meta,
            ))
        .toList();
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
  Future<void> markNotificationRead(String id) {
    return remote.markNotificationRead(id);
  }

  Future<void> cancelBooking(String bookingId, {String? reason}) {
  return remote.cancelBooking(bookingId, reason: reason);
  }

  Future<void> confirmPayment(String bookingId) {
  return remote.confirmPayment(bookingId);
  }
}