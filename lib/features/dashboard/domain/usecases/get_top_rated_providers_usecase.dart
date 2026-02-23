import '../entities/provider_entity.dart';
import '../repositories/i_dashboard_repository.dart';

class GetTopRatedProvidersUseCase {
  final IDashboardRepository repo;
  GetTopRatedProvidersUseCase(this.repo);

  Future<List<ProviderEntity>> call({int limit = 8}) => repo.getTopRatedProviders(limit: limit);
}