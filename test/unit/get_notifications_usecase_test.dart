import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sajilo_sewa/features/dashboard/domain/entities/notification_entity.dart';
import 'package:sajilo_sewa/features/dashboard/domain/repositories/i_dashboard_repository.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/get_notifications_usecase.dart';

class MockDashboardRepository extends Mock implements IDashboardRepository {}

void main() {
  late MockDashboardRepository mockRepository;
  late GetNotificationsUseCase useCase;

  setUp(() {
    mockRepository = MockDashboardRepository();
    useCase = GetNotificationsUseCase(mockRepository);
  });

  test('GetNotificationsUseCase returns notifications from repository',
      () async {
    const notifications = [
      NotificationEntity(
        id: 'n1',
        title: 'Booking Confirmed',
        message: 'Your booking has been confirmed',
        createdAt: '2026-03-08',
        isRead: false,
      ),
    ];

    when(() => mockRepository.getNotifications())
        .thenAnswer((_) async => notifications);

    final result = await useCase();

    expect(result.length, 1);
    expect(result.first.id, 'n1');
    expect(result.first.isRead, false);

    verify(() => mockRepository.getNotifications()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}