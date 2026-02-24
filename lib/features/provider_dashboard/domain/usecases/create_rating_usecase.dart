import '../repositories/i_provider_repository.dart';

class CreateRatingUseCase {
  final IProviderRepository repo;
  CreateRatingUseCase(this.repo);

  Future<void> call({
    required String bookingId,
    required int stars,
    String? comment,
  }) {
    return repo.createRating(bookingId: bookingId, stars: stars, comment: comment);
  }
}