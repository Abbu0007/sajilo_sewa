import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sajilo_sewa/features/dashboard/domain/entities/booking_entity.dart';
import 'package:sajilo_sewa/features/dashboard/domain/repositories/i_dashboard_repository.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/create_booking_usecase.dart';

class MockDashboardRepository extends Mock implements IDashboardRepository {}

void main() {
  late MockDashboardRepository mockRepository;
  late CreateBookingUseCase useCase;

  setUp(() {
    mockRepository = MockDashboardRepository();
    useCase = CreateBookingUseCase(mockRepository);
  });

  test('CreateBookingUseCase calls repo.createBooking and returns BookingEntity',
      () async {
    const booking = BookingEntity(
      id: 'b1',
      status: 'pending',
      scheduledAt: '2026-03-08T10:00:00.000Z',
    );

    when(() => mockRepository.createBooking(
          providerId: 'p1',
          serviceId: 's1',
          scheduledAt: '2026-03-08T10:00:00.000Z',
          addressText: 'Kathmandu',
          note: 'Call me first',
        )).thenAnswer((_) async => booking);

    final result = await useCase(
      providerId: 'p1',
      serviceId: 's1',
      scheduledAt: '2026-03-08T10:00:00.000Z',
      addressText: 'Kathmandu',
      note: 'Call me first',
    );

    expect(result.id, 'b1');
    expect(result.status, 'pending');

    verify(() => mockRepository.createBooking(
          providerId: 'p1',
          serviceId: 's1',
          scheduledAt: '2026-03-08T10:00:00.000Z',
          addressText: 'Kathmandu',
          note: 'Call me first',
        )).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}