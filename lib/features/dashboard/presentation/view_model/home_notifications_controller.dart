import 'package:flutter/foundation.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/mark_notification_read_usecase.dart';
import '../../domain/usecases/create_rating_usecase.dart';

class HomeNotificationsController extends ChangeNotifier {
  final GetNotificationsUseCase getNotifications;
  final MarkNotificationReadUseCase markRead;

  
  final CreateRatingUseCase createRating;

  HomeNotificationsController({
    required this.getNotifications,
    required this.markRead,
    required this.createRating, 
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
    } catch (_) {}
  }

  
  Future<void> submitRatingFromNotification({
    required String notificationId,
    required String bookingId,
    required int stars,
    String? comment,
  }) async {
    try {
      await createRating(
        bookingId: bookingId,
        stars: stars,
        comment: comment,
      );
      await markRead(notificationId);
      await load();
    } catch (_) {
      rethrow;
    }
  }
}