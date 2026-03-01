import '../entities/provider_me_entity.dart';
import '../repositories/i_provider_repository.dart';

class UpdateProviderMeUseCase {
  final IProviderRepository repo;
  UpdateProviderMeUseCase(this.repo);

  Future<ProviderMeEntity> call({
    required String firstName,
    required String lastName,
  }) {
    return repo.updateMe(firstName: firstName, lastName: lastName);
  }
}