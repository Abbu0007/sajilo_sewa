import '../repositories/i_dashboard_repository.dart';

class CancelBookingUseCase {
  final IDashboardRepository repo;

  CancelBookingUseCase(this.repo);

  Future<void> call(String bookingId, {String? reason}) {
    return repo.cancelBooking(bookingId, reason: reason);
  }
}