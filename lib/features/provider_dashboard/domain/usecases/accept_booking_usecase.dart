import '../entities/provider_booking_entity.dart';
import '../repositories/i_provider_repository.dart';

class AcceptBookingUseCase {
  final IProviderRepository repo;
  AcceptBookingUseCase(this.repo);

  Future<ProviderBookingEntity> call(String bookingId) => repo.acceptBooking(bookingId);
}