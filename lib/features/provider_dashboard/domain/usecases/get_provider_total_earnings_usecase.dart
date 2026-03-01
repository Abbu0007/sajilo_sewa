import '../repositories/i_provider_repository.dart';

class GetProviderTotalEarningsUseCase {
  final IProviderRepository repo;

  GetProviderTotalEarningsUseCase(this.repo);

  Future<num> call() async {
    final bookings = await repo.getProviderBookings(status: "completed");

    num total = 0;
    for (final b in bookings) {
      final status = (b.status ?? '').toString();
      final paymentStatus = (b.paymentStatus ?? '').toString();

      if (status == 'completed' && paymentStatus == 'paid') {
        total += (b.price ?? 0);
      }
    }
    return total;
  }
}