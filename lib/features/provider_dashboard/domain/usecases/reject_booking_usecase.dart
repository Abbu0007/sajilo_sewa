import '../entities/provider_booking_entity.dart';
import '../repositories/i_provider_repository.dart';

class RejectBookingUseCase {
  final IProviderRepository repo;
  RejectBookingUseCase(this.repo);

  Future<ProviderBookingEntity> call(String bookingId, {String? reason}) =>
      repo.rejectBooking(bookingId, reason: reason);
}