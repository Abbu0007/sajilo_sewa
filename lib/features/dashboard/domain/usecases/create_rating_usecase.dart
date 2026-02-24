import '../repositories/i_dashboard_repository.dart';

class CreateRatingUseCase {
  final IDashboardRepository repo;

  CreateRatingUseCase(this.repo);

  Future<void> call({
    required String bookingId,
    required int stars,
    String? comment,
  }) {
    return repo.createRating(
      bookingId: bookingId,
      stars: stars,
      comment: comment,
    );
  }
}