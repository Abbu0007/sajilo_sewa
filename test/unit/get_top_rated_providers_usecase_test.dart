import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sajilo_sewa/features/dashboard/domain/entities/provider_entity.dart';
import 'package:sajilo_sewa/features/dashboard/domain/repositories/i_dashboard_repository.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/get_top_rated_providers_usecase.dart';

class MockDashboardRepository extends Mock implements IDashboardRepository {}

void main() {
  late MockDashboardRepository mockRepository;
  late GetTopRatedProvidersUseCase useCase;

  setUp(() {
    mockRepository = MockDashboardRepository();
    useCase = GetTopRatedProvidersUseCase(mockRepository);
  });

  test('GetTopRatedProvidersUseCase calls repo with limit and returns result',
      () async {
    final providers = [
      ProviderEntity(
        id: 'p1',
        firstName: 'Sita',
        lastName: 'KC',
        email: 'sita@test.com',
        phone: '9800',
        profession: 'Painter',
        serviceSlug: 'painting',
        avatarUrl: null,
        avgRating: 4.9,
        ratingCount: 30,
        completedJobs: 120,
        startingPrice: 1000,
      ),
    ];

    when(() => mockRepository.getTopRatedProviders(limit: 8))
        .thenAnswer((_) async => providers);

    final result = await useCase();

    expect(result.length, 1);
    expect(result.first.avgRating, 4.9);

    verify(() => mockRepository.getTopRatedProviders(limit: 8)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}