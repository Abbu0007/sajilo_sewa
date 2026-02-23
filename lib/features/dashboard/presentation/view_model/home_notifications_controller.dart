import 'package:flutter/foundation.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/mark_notification_read_usecase.dart';

class HomeNotificationsController extends ChangeNotifier {
  final GetNotificationsUseCase getNotifications;
  final MarkNotificationReadUseCase markRead;

  HomeNotificationsController({
    required this.getNotifications,
    required this.markRead,
  });

  bool loading = false;
  String? error;
  List<NotificationEntity> items = [];

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
      // keep silent like your web bell does
    }
  }
}