import 'package:dartz/dartz.dart';
import 'package:sajilo_sewa/core/error/failures.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/repositories/i_admin_bookings_repository.dart';

class GetAdminBookingsUseCase {
  final IAdminBookingsRepository repo;
  GetAdminBookingsUseCase(this.repo);

  Future<Either<Failure, AdminBookingPageEntity>> call({
    required int page,
    required int limit,
    String status = 'all',
    String q = '',
    DateTime? dateFrom,
    DateTime? dateTo,
  }) {
    return repo.list(
      page: page,
      limit: limit,
      status: status,
      q: q,
      dateFrom: dateFrom,
      dateTo: dateTo,
    );
  }
}