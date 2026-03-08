import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sajilo_sewa/features/dashboard/domain/repositories/i_dashboard_repository.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/create_rating_usecase.dart';

class MockDashboardRepository extends Mock implements IDashboardRepository {}

void main() {
  late MockDashboardRepository mockRepository;
  late CreateRatingUseCase useCase;

  setUp(() {
    mockRepository = MockDashboardRepository();
    useCase = CreateRatingUseCase(mockRepository);
  });

  test('CreateRatingUseCase calls repo.createRating with correct values',
      () async {
    when(() => mockRepository.createRating(
          bookingId: 'b1',
          stars: 5,
          comment: 'Excellent service',
        )).thenAnswer((_) async {});

    await useCase(
      bookingId: 'b1',
      stars: 5,
      comment: 'Excellent service',
    );

    verify(() => mockRepository.createRating(
          bookingId: 'b1',
          stars: 5,
          comment: 'Excellent service',
        )).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}