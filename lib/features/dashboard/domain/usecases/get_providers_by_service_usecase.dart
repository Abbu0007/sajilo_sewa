import '../entities/provider_entity.dart';
import '../repositories/i_dashboard_repository.dart';

class GetProvidersByServiceUseCase {
  final IDashboardRepository repo;
  GetProvidersByServiceUseCase(this.repo);

  Future<List<ProviderEntity>> call(String slug) => repo.getProvidersByService(slug);
}