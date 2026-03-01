import 'package:dartz/dartz.dart';
import 'package:sajilo_sewa/core/error/failures.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/repositories/i_admin_bookings_repository.dart';

class DeleteAdminBookingUseCase {
  final IAdminBookingsRepository repo;
  DeleteAdminBookingUseCase(this.repo);

  Future<Either<Failure, void>> call(String id) {
    return repo.delete(id);
  }
}