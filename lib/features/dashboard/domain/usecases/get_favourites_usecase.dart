import '../entities/provider_entity.dart';
import '../repositories/i_dashboard_repository.dart';

class GetFavouritesUseCase {
  final IDashboardRepository repo;
  GetFavouritesUseCase(this.repo);

  Future<List<ProviderEntity>> call() => repo.getFavourites();
}