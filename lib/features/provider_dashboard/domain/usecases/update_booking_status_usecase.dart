import '../repositories/i_provider_repository.dart';
import '../entities/provider_booking_entity.dart';

class UpdateBookingStatusUseCase {
  final IProviderRepository repo;

  UpdateBookingStatusUseCase(this.repo);

  Future<ProviderBookingEntity> call(
    String bookingId, {
    required String status,
    String? reason,
    num? price,
  }) {
    return repo.updateBookingStatus(
      bookingId,
      status: status,
      reason: reason,
      price: price,
    );
  }
}