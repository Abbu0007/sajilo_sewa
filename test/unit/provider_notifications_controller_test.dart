import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sajilo_sewa/features/provider_dashboard/domain/entities/provider_notification_entity.dart';
import 'package:sajilo_sewa/features/provider_dashboard/domain/usecases/get_provider_notifications_usecase.dart';
import 'package:sajilo_sewa/features/provider_dashboard/domain/usecases/mark_provider_notification_read_usecase.dart';
import 'package:sajilo_sewa/features/provider_dashboard/presentation/view_model/provider_notifications_controller.dart';

class MockGetProviderNotificationsUseCase extends Mock
    implements GetProviderNotificationsUseCase {}

class MockMarkProviderNotificationReadUseCase extends Mock
    implements MarkProviderNotificationReadUseCase {}

void main() {
  late MockGetProviderNotificationsUseCase mockGetProviderNotificationsUseCase;
  late MockMarkProviderNotificationReadUseCase
      mockMarkProviderNotificationReadUseCase;
  late ProviderNotificationsController controller;

  setUp(() {
    mockGetProviderNotificationsUseCase = MockGetProviderNotificationsUseCase();
    mockMarkProviderNotificationReadUseCase =
        MockMarkProviderNotificationReadUseCase();

    controller = ProviderNotificationsController(
      getNotifications: mockGetProviderNotificationsUseCase,
      markRead: mockMarkProviderNotificationReadUseCase,
    );
  });

  testWidgets('provider notifications controller initial state is correct',
      (tester) async {
    await tester.pump();

    expect(controller.loading, false);
    expect(controller.error, null);
    expect(controller.items, isEmpty);
    expect(controller.unreadCount, 0);
  });

  testWidgets('provider notifications controller load updates items',
      (tester) async {
    final items = [
      const ProviderNotificationEntity(
        id: 'n1',
        type: 'booking_request',
        title: 'Booking',
        message: 'New booking',
        createdAt: '2026-03-08',
        isRead: false,
        bookingId: 'b1',
      ),
      const ProviderNotificationEntity(
        id: 'n2',
        type: 'booking_update',
        title: 'Update',
        message: 'Updated',
        createdAt: '2026-03-08',
        isRead: true,
        bookingId: 'b2',
      ),
    ];

    when(() => mockGetProviderNotificationsUseCase.call())
        .thenAnswer((_) async => items);

    await controller.load();
    await tester.pump();

    expect(controller.loading, false);
    expect(controller.error, null);
    expect(controller.items.length, 2);
    expect(controller.unreadCount, 1);
  });

  testWidgets('provider notifications controller load sets error on failure',
      (tester) async {
    when(() => mockGetProviderNotificationsUseCase.call())
        .thenThrow(Exception('Failed to load provider notifications'));

    await controller.load();
    await tester.pump();

    expect(controller.loading, false);
    expect(controller.error, 'Failed to load provider notifications');
  });

  testWidgets('provider notifications controller markAsReadAndRefresh works',
      (tester) async {
    when(() => mockMarkProviderNotificationReadUseCase.call('n1'))
        .thenAnswer((_) async {});
    when(() => mockGetProviderNotificationsUseCase.call())
        .thenAnswer((_) async => []);

    await controller.markAsReadAndRefresh('n1');
    await tester.pump();

    verify(() => mockMarkProviderNotificationReadUseCase.call('n1')).called(1);
    verify(() => mockGetProviderNotificationsUseCase.call()).called(1);
  });
}