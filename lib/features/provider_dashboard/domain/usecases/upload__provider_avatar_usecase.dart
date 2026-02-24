import '../entities/provider_me_entity.dart';
import '../repositories/i_provider_repository.dart';

class UploadProviderAvatarUseCase {
  final IProviderRepository repo;
  UploadProviderAvatarUseCase(this.repo);

  Future<ProviderMeEntity> call(String filePath) => repo.uploadAvatar(filePath);
}