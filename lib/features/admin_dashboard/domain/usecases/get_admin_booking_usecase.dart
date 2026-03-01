import 'package:dartz/dartz.dart';
import 'package:sajilo_sewa/core/error/failures.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/entities/admin_booking_entity.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/repositories/i_admin_bookings_repository.dart';

class GetAdminBookingUseCase {
  final IAdminBookingsRepository repo;
  GetAdminBookingUseCase(this.repo);

  Future<Either<Failure, AdminBookingEntity>> call(String id) {
    return repo.getById(id);
  }
}