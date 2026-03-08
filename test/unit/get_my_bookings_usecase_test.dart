import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sajilo_sewa/features/dashboard/domain/entities/booking_entity.dart';
import 'package:sajilo_sewa/features/dashboard/domain/repositories/i_dashboard_repository.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/get_my_bookings_usecase.dart';

class MockDashboardRepository extends Mock implements IDashboardRepository {}

void main() {
  late MockDashboardRepository mockRepository;
  late GetMyBookingsUseCase useCase;

  setUp(() {
    mockRepository = MockDashboardRepository();
    useCase = GetMyBookingsUseCase(mockRepository);
  });

  test('GetMyBookingsUseCase calls repo.getMyBookings with status filter',
      () async {
    const bookings = [
      BookingEntity(
        id: 'b1',
        status: 'pending',
        scheduledAt: '2026-03-08T10:00:00.000Z',
      ),
    ];

    when(() => mockRepository.getMyBookings(status: 'pending'))
        .thenAnswer((_) async => bookings);

    final result = await useCase(status: 'pending');

    expect(result.length, 1);
    expect(result.first.status, 'pending');

    verify(() => mockRepository.getMyBookings(status: 'pending')).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}