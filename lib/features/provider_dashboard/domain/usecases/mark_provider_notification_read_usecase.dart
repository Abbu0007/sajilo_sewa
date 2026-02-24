import '../repositories/i_provider_repository.dart';

class MarkProviderNotificationReadUseCase {
  final IProviderRepository repo;
  MarkProviderNotificationReadUseCase(this.repo);

  Future<void> call(String id) {
    return repo.markNotificationRead(id);
  }
}