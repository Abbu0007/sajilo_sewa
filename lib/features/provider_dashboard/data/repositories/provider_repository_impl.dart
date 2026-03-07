import 'package:sajilo_sewa/features/provider_dashboard/domain/entities/provider_booking_entity.dart';
import 'package:sajilo_sewa/features/provider_dashboard/domain/entities/provider_notification_entity.dart';
import '../../domain/entities/provider_me_entity.dart';
import '../../domain/entities/provider_profile_entity.dart';
import '../../domain/repositories/i_provider_repository.dart';
import '../datasources/local/provider_local_datasource.dart';
import '../datasources/remote/provider_remote_datasource.dart';
import '../models/provider_booking_api_model.dart';
import '../models/provider_booking_hive_model.dart';
import '../models/provider_me_hive_model.dart';
import '../models/provider_notification_hive_model.dart';
import '../models/provider_profile_hive_model.dart';

class ProviderRepositoryImpl implements IProviderRepository {
  final ProviderRemoteDataSource remote;
  final ProviderLocalDataSource local;

  ProviderRepositoryImpl({
    required this.remote,
    required this.local,
  });

  ProviderMeEntity _mapMe(dynamic m) {
    return ProviderMeEntity(
      id: m.id,
      firstName: m.firstName,
      lastName: m.lastName,
      email: m.email,
      phone: m.phone,
      avatarUrl: m.avatarUrl,
      role: m.role,
      profession: m.profession,
      avgRating: m.avgRating,
      ratingCount: m.ratingCount,
    );
  }

  ProviderMeHiveModel _mapMeToHive(dynamic m) {
    return ProviderMeHiveModel(
      id: m.id,
      firstName: m.firstName,
      lastName: m.lastName,
      email: m.email,
      phone: m.phone,
      avatarUrl: m.avatarUrl,
      role: m.role,
      profession: m.profession,
      avgRating: m.avgRating?.toDouble(),
      ratingCount: m.ratingCount?.toDouble(),
    );
  }

  ProviderMeEntity _mapMeHiveToEntity(ProviderMeHiveModel m) {
    return ProviderMeEntity(
      id: m.id,
      firstName: m.firstName,
      lastName: m.lastName,
      email: m.email,
      phone: m.phone,
      avatarUrl: m.avatarUrl,
      role: m.role,
      profession: m.profession,
      avgRating: m.avgRating,
      ratingCount: m.ratingCount,
    );
  }

  @override
  Future<ProviderMeEntity> getMe() async {
    try {
      final m = await remote.getMe();
      await local.cacheMe(_mapMeToHive(m));
      return _mapMe(m);
    } catch (_) {
      final cached = await local.getCachedMe();
      if (cached != null) return _mapMeHiveToEntity(cached);
      rethrow;
    }
  }

  @override
  Future<ProviderProfileEntity?> getMyProviderProfile() async {
    try {
      final m = await remote.getMyProviderProfile();
      if (m == null) return null;

      await local.cacheProfile(
        ProviderProfileHiveModel(
          id: m.id,
          userId: m.userId,
          profession: m.profession,
          bio: m.bio,
          startingPrice: m.startingPrice?.toDouble(),
          serviceAreas: m.serviceAreas,
          availability: m.availability,
          ratingAvg: m.ratingAvg.toDouble(),
          ratingCount: m.ratingCount.toDouble(),
          completedJobs: m.completedJobs.toDouble(),
        ),
      );

      return ProviderProfileEntity(
        id: m.id,
        userId: m.userId,
        profession: m.profession,
        bio: m.bio,
        startingPrice: m.startingPrice,
        serviceAreas: m.serviceAreas,
        availability: m.availability,
        ratingAvg: m.ratingAvg,
        ratingCount: m.ratingCount,
        completedJobs: m.completedJobs,
      );
    } catch (_) {
      final cached = await local.getCachedProfile();
      if (cached == null) return null;

      return ProviderProfileEntity(
        id: cached.id,
        userId: cached.userId,
        profession: cached.profession,
        bio: cached.bio,
        startingPrice: cached.startingPrice,
        serviceAreas: cached.serviceAreas,
        availability: cached.availability,
        ratingAvg: cached.ratingAvg,
        ratingCount: cached.ratingCount,
        completedJobs: cached.completedJobs,
      );
    }
  }

  @override
  Future<ProviderProfileEntity> updateMyProviderProfile({
    required String profession,
    String? bio,
    num? startingPrice,
    List<String>? serviceAreas,
    String? availability,
  }) async {
    final m = await remote.updateMyProviderProfile(
      profession: profession,
      bio: bio,
      startingPrice: startingPrice,
      serviceAreas: serviceAreas,
      availability: availability,
    );

    await local.cacheProfile(
      ProviderProfileHiveModel(
        id: m.id,
        userId: m.userId,
        profession: m.profession,
        bio: m.bio,
        startingPrice: m.startingPrice?.toDouble(),
        serviceAreas: m.serviceAreas,
        availability: m.availability,
        ratingAvg: m.ratingAvg.toDouble(),
        ratingCount: m.ratingCount.toDouble(),
        completedJobs: m.completedJobs.toDouble(),
      ),
    );

    return ProviderProfileEntity(
      id: m.id,
      userId: m.userId,
      profession: m.profession,
      bio: m.bio,
      startingPrice: m.startingPrice,
      serviceAreas: m.serviceAreas,
      availability: m.availability,
      ratingAvg: m.ratingAvg,
      ratingCount: m.ratingCount,
      completedJobs: m.completedJobs,
    );
  }

  @override
  Future<List<ProviderBookingEntity>> getProviderBookings({
    String status = "all",
  }) async {
    try {
      final items = await remote.getProviderBookings(status: status);

      await local.cacheBookings(
        items.map(_mapBookingToHive).toList(),
        replace: status == 'all',
      );

      return items.map(_mapBooking).toList();
    } catch (_) {
      final cached = await local.getCachedBookings(status: status);
      return cached.map(_mapBookingHiveToEntity).toList();
    }
  }

  @override
  Future<ProviderBookingEntity> acceptBooking(String bookingId) async {
    final b = await remote.acceptBooking(bookingId);
    await local.cacheBookings([_mapBookingToHive(b)], replace: false);
    return _mapBooking(b);
  }

  @override
  Future<ProviderBookingEntity> rejectBooking(
    String bookingId, {
    String? reason,
  }) async {
    final b = await remote.rejectBooking(bookingId, reason: reason);
    await local.cacheBookings([_mapBookingToHive(b)], replace: false);
    return _mapBooking(b);
  }

  @override
  Future<ProviderBookingEntity> updateBookingStatus(
    String bookingId, {
    required String status,
    String? reason,
    num? price,
  }) async {
    final b = await remote.updateBookingStatus(
      bookingId,
      status: status,
      reason: reason,
      price: price,
    );
    await local.cacheBookings([_mapBookingToHive(b)], replace: false);
    return _mapBooking(b);
  }

  @override
  Future<ProviderMeEntity> updateMe({
    required String firstName,
    required String lastName,
  }) async {
    final model = await remote.updateMe(
      firstName: firstName,
      lastName: lastName,
    );

    await local.cacheMe(_mapMeToHive(model));
    return _mapMe(model);
  }

  @override
  Future<ProviderMeEntity> uploadAvatar(String filePath) async {
    final model = await remote.uploadAvatar(filePath);
    await local.cacheMe(_mapMeToHive(model));
    return _mapMe(model);
  }

  @override
  Future<List<ProviderNotificationEntity>> getNotifications() async {
    try {
      final items = await remote.getNotifications();

      await local.cacheNotifications(
        items
            .map(
              (n) => ProviderNotificationHiveModel(
                id: n.id,
                type: n.type,
                title: n.title ?? 'Notification',
                message: n.message ?? '',
                createdAt: n.createdAt,
                isRead: n.isRead,
                bookingId: n.bookingId,
              ),
            )
            .toList(),
      );

      return items
          .map(
            (n) => ProviderNotificationEntity(
              id: n.id,
              type: n.type,
              title: n.title ?? 'Notification',
              message: n.message ?? '',
              createdAt: n.createdAt,
              isRead: n.isRead,
              bookingId: n.bookingId,
            ),
          )
          .toList();
    } catch (_) {
      final cached = await local.getCachedNotifications();

      return cached
          .map(
            (n) => ProviderNotificationEntity(
              id: n.id,
              type: n.type,
              title: n.title,
              message: n.message,
              createdAt: n.createdAt,
              isRead: n.isRead,
              bookingId: n.bookingId,
            ),
          )
          .toList();
    }
  }

  @override
  Future<void> markNotificationRead(String id) async {
    await remote.markNotificationRead(id);
    await local.markCachedNotificationAsRead(id);
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

  ProviderBookingEntity _mapBooking(ProviderBookingApiModel b) {
    return ProviderBookingEntity(
      id: b.id,
      status: b.status,
      scheduledAt: b.scheduledAt,
      note: b.note,
      addressText: b.addressText,
      price: b.price,
      paymentStatus: b.paymentStatus,
      client: b.client == null
          ? null
          : ProviderBookingClientEntity(
              id: b.client!.id,
              firstName: b.client!.firstName,
              lastName: b.client!.lastName,
              phone: b.client!.phone,
              email: b.client!.email,
              avatarUrl: b.client!.avatarUrl,
            ),
      service: b.service == null
          ? null
          : ProviderBookingServiceEntity(
              id: b.service!.id,
              name: b.service!.name,
              icon: b.service!.icon,
              basePriceFrom: b.service!.basePriceFrom,
            ),
    );
  }

  ProviderBookingHiveModel _mapBookingToHive(ProviderBookingApiModel b) {
    return ProviderBookingHiveModel(
      id: b.id,
      status: b.status,
      scheduledAt: b.scheduledAt,
      note: b.note,
      addressText: b.addressText,
      price: b.price?.toDouble(),
      paymentStatus: b.paymentStatus,
      clientId: b.client?.id,
      clientFirstName: b.client?.firstName,
      clientLastName: b.client?.lastName,
      clientPhone: b.client?.phone,
      clientEmail: b.client?.email,
      clientAvatarUrl: b.client?.avatarUrl,
      serviceId: b.service?.id,
      serviceName: b.service?.name,
      serviceIcon: b.service?.icon,
      serviceBasePriceFrom: b.service?.basePriceFrom?.toDouble(),
    );
  }

  ProviderBookingEntity _mapBookingHiveToEntity(ProviderBookingHiveModel b) {
    return ProviderBookingEntity(
      id: b.id,
      status: b.status,
      scheduledAt: b.scheduledAt,
      note: b.note,
      addressText: b.addressText,
      price: b.price,
      paymentStatus: b.paymentStatus,
      client: b.clientId == null
          ? null
          : ProviderBookingClientEntity(
              id: b.clientId ?? '',
              firstName: b.clientFirstName ?? '',
              lastName: b.clientLastName ?? '',
              phone: b.clientPhone,
              email: b.clientEmail,
              avatarUrl: b.clientAvatarUrl,
            ),
      service: b.serviceId == null
          ? null
          : ProviderBookingServiceEntity(
              id: b.serviceId ?? '',
              name: b.serviceName ?? '',
              icon: b.serviceIcon,
              basePriceFrom: b.serviceBasePriceFrom,
            ),
    );
  }
}