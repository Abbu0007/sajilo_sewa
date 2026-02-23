import '../entities/notification_entity.dart';
import '../repositories/i_dashboard_repository.dart';

class GetNotificationsUseCase {
  final IDashboardRepository repo;
  GetNotificationsUseCase(this.repo);

  Future<List<NotificationEntity>> call() => repo.getNotifications();
}