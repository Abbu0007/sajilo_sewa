import '../entities/provider_notification_entity.dart';
import '../repositories/i_provider_repository.dart';

class GetProviderNotificationsUseCase {
  final IProviderRepository repo;
  GetProviderNotificationsUseCase(this.repo);

  Future<List<ProviderNotificationEntity>> call() {
    return repo.getNotifications();
  }
}