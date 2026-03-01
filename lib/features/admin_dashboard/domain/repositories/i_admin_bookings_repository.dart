import 'package:dartz/dartz.dart';
import 'package:sajilo_sewa/core/error/failures.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/entities/admin_booking_entity.dart';

class AdminBookingPageEntity {
  final List<AdminBookingEntity> items;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  const AdminBookingPageEntity({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });
}

abstract class IAdminBookingsRepository {
  Future<Either<Failure, AdminBookingPageEntity>> list({
    required int page,
    required int limit,
    String status,
    String q,
    DateTime? dateFrom,
    DateTime? dateTo,
  });

  Future<Either<Failure, AdminBookingEntity>> getById(String id);

  Future<Either<Failure, AdminBookingEntity>> cancel({
    required String id,
    required String reason,
  });

  Future<Either<Failure, void>> delete(String id);
}