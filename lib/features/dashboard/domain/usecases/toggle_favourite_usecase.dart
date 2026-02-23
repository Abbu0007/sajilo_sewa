import '../repositories/i_dashboard_repository.dart';

class ToggleFavouriteUseCase {
  final IDashboardRepository repo;
  ToggleFavouriteUseCase(this.repo);

  Future<bool> call(String providerId) => repo.toggleFavourite(providerId);
}