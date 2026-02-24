import '../entities/provider_booking_entity.dart';
import '../repositories/i_provider_repository.dart';

class UpdateBookingStatusUseCase {
  final IProviderRepository repo;
  UpdateBookingStatusUseCase(this.repo);

  Future<ProviderBookingEntity> call(
    String bookingId, {
    required String status,
    String? reason,
  }) =>
      repo.updateBookingStatus(bookingId, status: status, reason: reason);
}