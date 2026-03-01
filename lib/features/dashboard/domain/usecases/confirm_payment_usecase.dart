import '../repositories/i_dashboard_repository.dart';

class ConfirmPaymentUseCase {
  final IDashboardRepository repo;

  ConfirmPaymentUseCase(this.repo);

  Future<void> call(String bookingId) {
    return repo.confirmPayment(bookingId);
  }
}