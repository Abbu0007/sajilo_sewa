import '../entities/service_entity.dart';
import '../repositories/i_dashboard_repository.dart';

class GetServicesUseCase {
  final IDashboardRepository repo;
  GetServicesUseCase(this.repo);

  Future<List<ServiceEntity>> call() => repo.getServices();
}