import '../entities/provider_profile_entity.dart';
import '../repositories/i_provider_repository.dart';

class GetProviderProfileUseCase {
  final IProviderRepository repo;
  GetProviderProfileUseCase(this.repo);

  Future<ProviderProfileEntity?> call() => repo.getMyProviderProfile();
}