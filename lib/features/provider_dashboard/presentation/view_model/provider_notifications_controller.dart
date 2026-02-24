import 'package:flutter/foundation.dart';
import '../../domain/entities/provider_notification_entity.dart';
import '../../domain/usecases/get_provider_notifications_usecase.dart';
import '../../domain/usecases/mark_provider_notification_read_usecase.dart';

class ProviderNotificationsController extends ChangeNotifier {
  final GetProviderNotificationsUseCase getNotifications;
  final MarkProviderNotificationReadUseCase markRead;

  ProviderNotificationsController({
    required this.getNotifications,
    required this.markRead,
  });

  bool loading = false;
  String? error;
  List<ProviderNotificationEntity> items = [];

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      items = await getNotifications();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  int get unreadCount => items.where((x) => !x.isRead).length;

  Future<void> markAsReadAndRefresh(String id) async {
    try {
      await markRead(id);
      await load();
    } catch (_) {
      // silent
    }
  }
}