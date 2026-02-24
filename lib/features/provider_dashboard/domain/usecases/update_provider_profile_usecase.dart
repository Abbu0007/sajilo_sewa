import '../entities/provider_profile_entity.dart';
import '../repositories/i_provider_repository.dart';

class UpdateProviderProfileUseCase {
  final IProviderRepository repo;
  UpdateProviderProfileUseCase(this.repo);

  Future<ProviderProfileEntity> call({
    required String profession,
    String? bio,
    num? startingPrice,
    List<String>? serviceAreas,
    String? availability,
  }) =>
      repo.updateMyProviderProfile(
        profession: profession,
        bio: bio,
        startingPrice: startingPrice,
        serviceAreas: serviceAreas,
        availability: availability,
      );
}