import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sajilo_sewa/features/dashboard/domain/entities/provider_entity.dart';
import 'package:sajilo_sewa/features/dashboard/domain/repositories/i_dashboard_repository.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/get_providers_by_service_usecase.dart';

class MockDashboardRepository extends Mock implements IDashboardRepository {}

void main() {
  late MockDashboardRepository mockRepository;
  late GetProvidersByServiceUseCase useCase;

  setUp(() {
    mockRepository = MockDashboardRepository();
    useCase = GetProvidersByServiceUseCase(mockRepository);
  });

  test('GetProvidersByServiceUseCase calls repo with service slug', () async {
    final providers = [
      ProviderEntity(
        id: 'p1',
        firstName: 'Ram',
        lastName: 'Sharma',
        email: 'ram@test.com',
        phone: '9800',
        profession: 'Plumber',
        serviceSlug: 'plumbing',
        avatarUrl: null,
        avgRating: 4.5,
        ratingCount: 10,
        completedJobs: 50,
        startingPrice: 700,
      ),
    ];

    when(() => mockRepository.getProvidersByService('plumbing'))
        .thenAnswer((_) async => providers);

    final result = await useCase('plumbing');

    expect(result.length, 1);
    expect(result.first.serviceSlug, 'plumbing');

    verify(() => mockRepository.getProvidersByService('plumbing')).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}