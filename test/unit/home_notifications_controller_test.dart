import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sajilo_sewa/features/dashboard/domain/entities/notification_entity.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/create_rating_usecase.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/get_notifications_usecase.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/mark_notification_read_usecase.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/view_model/home_notifications_controller.dart';

class MockGetNotificationsUseCase extends Mock
    implements GetNotificationsUseCase {}

class MockMarkNotificationReadUseCase extends Mock
    implements MarkNotificationReadUseCase {}

class MockCreateRatingUseCase extends Mock implements CreateRatingUseCase {}

void main() {
  late MockGetNotificationsUseCase mockGetNotificationsUseCase;
  late MockMarkNotificationReadUseCase mockMarkNotificationReadUseCase;
  late MockCreateRatingUseCase mockCreateRatingUseCase;
  late HomeNotificationsController controller;

  setUp(() {
    mockGetNotificationsUseCase = MockGetNotificationsUseCase();
    mockMarkNotificationReadUseCase = MockMarkNotificationReadUseCase();
    mockCreateRatingUseCase = MockCreateRatingUseCase();

    controller = HomeNotificationsController(
      getNotifications: mockGetNotificationsUseCase,
      markRead: mockMarkNotificationReadUseCase,
      createRating: mockCreateRatingUseCase,
    );
  });

  testWidgets('home notifications controller initial state is correct',
      (tester) async {
    await tester.pump();

    expect(controller.loading, false);
    expect(controller.error, null);
    expect(controller.items, isEmpty);
    expect(controller.unreadCount, 0);
  });

  testWidgets('home notifications controller load updates items',
      (tester) async {
    final notifications = [
      const NotificationEntity(
        id: 'n1',
        title: 'Booking',
        message: 'Test',
        createdAt: '2026-03-08',
        isRead: false,
      ),
      const NotificationEntity(
        id: 'n2',
        title: 'Booking',
        message: 'Test 2',
        createdAt: '2026-03-08',
        isRead: true,
      ),
    ];

    when(() => mockGetNotificationsUseCase.call())
        .thenAnswer((_) async => notifications);

    await controller.load();
    await tester.pump();

    expect(controller.items.length, 2);
    expect(controller.unreadCount, 1);
    expect(controller.error, null);
  });

  testWidgets('home notifications controller load sets error on failure',
      (tester) async {
    when(() => mockGetNotificationsUseCase.call())
        .thenThrow(Exception('Failed to load notifications'));

    await controller.load();
    await tester.pump();

    expect(controller.loading, false);
    expect(controller.error, 'Failed to load notifications');
  });

  testWidgets('home notifications controller markAsReadAndRefresh works',
      (tester) async {
    when(() => mockMarkNotificationReadUseCase.call('n1'))
        .thenAnswer((_) async {});
    when(() => mockGetNotificationsUseCase.call()).thenAnswer((_) async => []);

    await controller.markAsReadAndRefresh('n1');
    await tester.pump();

    verify(() => mockMarkNotificationReadUseCase.call('n1')).called(1);
    verify(() => mockGetNotificationsUseCase.call()).called(1);
  });

  testWidgets('home notifications controller submitRatingFromNotification works',
      (tester) async {
    when(() => mockCreateRatingUseCase.call(
          bookingId: 'b1',
          stars: 5,
          comment: 'Great',
        )).thenAnswer((_) async {});
    when(() => mockMarkNotificationReadUseCase.call('n1'))
        .thenAnswer((_) async {});
    when(() => mockGetNotificationsUseCase.call()).thenAnswer((_) async => []);

    await controller.submitRatingFromNotification(
      notificationId: 'n1',
      bookingId: 'b1',
      stars: 5,
      comment: 'Great',
    );
    await tester.pump();

    verify(() => mockCreateRatingUseCase.call(
          bookingId: 'b1',
          stars: 5,
          comment: 'Great',
        )).called(1);
    verify(() => mockMarkNotificationReadUseCase.call('n1')).called(1);
    verify(() => mockGetNotificationsUseCase.call()).called(1);
  });
}