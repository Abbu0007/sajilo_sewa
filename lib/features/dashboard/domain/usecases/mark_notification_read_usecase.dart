import '../repositories/i_dashboard_repository.dart';

class MarkNotificationReadUseCase {
  final IDashboardRepository repo;
  MarkNotificationReadUseCase(this.repo);

  Future<void> call(String id) => repo.markNotificationRead(id);
}