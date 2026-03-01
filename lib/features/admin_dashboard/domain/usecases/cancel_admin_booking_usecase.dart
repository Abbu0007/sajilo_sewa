import 'package:dartz/dartz.dart';
import 'package:sajilo_sewa/core/error/failures.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/entities/admin_booking_entity.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/repositories/i_admin_bookings_repository.dart';

class CancelAdminBookingUseCase {
  final IAdminBookingsRepository repo;
  CancelAdminBookingUseCase(this.repo);

  Future<Either<Failure, AdminBookingEntity>> call({
    required String id,
    required String reason,
  }) {
    return repo.cancel(id: id, reason: reason);
  }
}