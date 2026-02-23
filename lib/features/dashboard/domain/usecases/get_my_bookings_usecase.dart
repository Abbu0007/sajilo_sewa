import '../entities/booking_entity.dart';
import '../repositories/i_dashboard_repository.dart';

class GetMyBookingsUseCase {
  final IDashboardRepository repo;
  GetMyBookingsUseCase(this.repo);

  Future<List<BookingEntity>> call({String status = "all"}) => repo.getMyBookings(status: status);
}