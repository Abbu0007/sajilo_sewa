import '../entities/booking_entity.dart';
import '../repositories/i_dashboard_repository.dart';

class CreateBookingUseCase {
  final IDashboardRepository repo;
  CreateBookingUseCase(this.repo);

  Future<BookingEntity> call({
    required String providerId,
    required String serviceId,
    required String scheduledAt,
    String? addressText,
    String? note,
  }) {
    return repo.createBooking(
      providerId: providerId,
      serviceId: serviceId,
      scheduledAt: scheduledAt,
      addressText: addressText,
      note: note,
    );
  }
}