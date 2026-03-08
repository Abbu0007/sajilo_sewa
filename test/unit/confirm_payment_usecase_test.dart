import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sajilo_sewa/features/dashboard/domain/repositories/i_dashboard_repository.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/confirm_payment_usecase.dart';

class MockDashboardRepository extends Mock implements IDashboardRepository {}

void main() {
  late MockDashboardRepository mockRepository;
  late ConfirmPaymentUseCase useCase;

  setUp(() {
    mockRepository = MockDashboardRepository();
    useCase = ConfirmPaymentUseCase(mockRepository);
  });

  test('ConfirmPaymentUseCase calls repo.confirmPayment with correct bookingId',
      () async {
    when(() => mockRepository.confirmPayment('b1')).thenAnswer((_) async {});

    await useCase('b1');

    verify(() => mockRepository.confirmPayment('b1')).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}