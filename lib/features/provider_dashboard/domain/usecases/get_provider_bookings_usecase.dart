import '../entities/provider_booking_entity.dart';
import '../repositories/i_provider_repository.dart';

class GetProviderBookingsUseCase {
  final IProviderRepository repo;
  GetProviderBookingsUseCase(this.repo);

  Future<List<ProviderBookingEntity>> call({String status = "all"}) =>
      repo.getProviderBookings(status: status);
}