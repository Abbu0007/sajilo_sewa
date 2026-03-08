import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sajilo_sewa/features/dashboard/domain/repositories/i_dashboard_repository.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/cancel_booking_usecase.dart';

class MockDashboardRepository extends Mock implements IDashboardRepository {}

void main() {
  late MockDashboardRepository mockRepository;
  late CancelBookingUseCase useCase;

  setUp(() {
    mockRepository = MockDashboardRepository();
    useCase = CancelBookingUseCase(mockRepository);
  });

  test('CancelBookingUseCase calls repo.cancelBooking with correct values', () async {
    when(() => mockRepository.cancelBooking('b1', reason: 'Busy'))
        .thenAnswer((_) async {});

    await useCase('b1', reason: 'Busy');

    verify(() => mockRepository.cancelBooking('b1', reason: 'Busy')).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}