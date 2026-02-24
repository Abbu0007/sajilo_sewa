
import 'package:sajilo_sewa/features/provider_dashboard/domain/entities/provider_booking_entity.dart';
import 'package:sajilo_sewa/features/provider_dashboard/domain/entities/provider_notification_entity.dart';

import '../../domain/entities/provider_me_entity.dart';
import '../../domain/entities/provider_profile_entity.dart';
import '../../domain/repositories/i_provider_repository.dart';
import '../datasources/remote/provider_remote_datasource.dart';

class ProviderRepositoryImpl implements IProviderRepository {
  final ProviderRemoteDataSource remote;

  ProviderRepositoryImpl({required this.remote});

  @override
  Future<ProviderMeEntity> getMe() async {
    final m = await remote.getMe();
    return ProviderMeEntity(
      id: m.id,
      firstName: m.firstName,
      lastName: m.lastName,
      email: m.email,
      phone: m.phone,
      avatarUrl: m.avatarUrl,
      role: m.role,
      avgRating: m.avgRating,
      ratingCount: m.ratingCount,
    );
  }

  @override
  Future<ProviderProfileEntity?> getMyProviderProfile() async {
    final m = await remote.getMyProviderProfile();
    if (m == null) return null;
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
  Future<List<ProviderBookingEntity>> getProviderBookings({String status = "all"}) async {
    final items = await remote.getProviderBookings(status: status);
    return items.map((b) {
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
    }).toList();
  }

  @override
  Future<ProviderBookingEntity> acceptBooking(String bookingId) async {
    final b = await remote.acceptBooking(bookingId);
    return _mapBooking(b);
  }

  @override
  Future<ProviderBookingEntity> rejectBooking(String bookingId, {String? reason}) async {
    final b = await remote.rejectBooking(bookingId, reason: reason);
    return _mapBooking(b);
  }

  @override
  Future<ProviderBookingEntity> updateBookingStatus(
    String bookingId, {
    required String status,
    String? reason,
  }) async {
    final b = await remote.updateBookingStatus(bookingId, status: status, reason: reason);
    return _mapBooking(b);
  }

  @override
  Future<ProviderMeEntity> uploadAvatar(String filePath) async {
    final m = await remote.uploadAvatar(filePath);
    return ProviderMeEntity(
      id: m.id,
      firstName: m.firstName,
      lastName: m.lastName,
      email: m.email,
      phone: m.phone,
      avatarUrl: m.avatarUrl,
      role: m.role,
      avgRating: m.avgRating,
      ratingCount: m.ratingCount,
    );
  }

  ProviderBookingEntity _mapBooking(dynamic b) {
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

  @override
  Future<List<ProviderNotificationEntity>> getNotifications() async {
  final models = await remote.getNotifications();
  return models
      .map((m) => ProviderNotificationEntity(
            id: m.id,
            title: (m.title ?? "Notification"),
            message: (m.message ?? ""),
            createdAt: m.createdAt,
            isRead: m.isRead, 
            type: m.type, 
            bookingId: m.bookingId,
          ))
      .toList();
  }

  @override
  Future<void> markNotificationRead(String id) {
  return remote.markNotificationRead(id);
  }

  @override
  Future<void> createRating({
  required String bookingId,
  required int stars,
  String? comment,
  }) {
  return remote.createRating(bookingId: bookingId, stars: stars, comment: comment);
  }

}