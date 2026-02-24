import '../entities/provider_me_entity.dart';
import '../repositories/i_provider_repository.dart';

class GetProviderMeUseCase {
  final IProviderRepository repo;
  GetProviderMeUseCase(this.repo);

  Future<ProviderMeEntity> call() => repo.getMe();
}