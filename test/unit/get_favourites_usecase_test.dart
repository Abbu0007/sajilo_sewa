import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sajilo_sewa/features/dashboard/domain/entities/provider_entity.dart';
import 'package:sajilo_sewa/features/dashboard/domain/repositories/i_dashboard_repository.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/get_favourites_usecase.dart';

class MockDashboardRepository extends Mock implements IDashboardRepository {}

void main() {
  late MockDashboardRepository mockRepository;
  late GetFavouritesUseCase useCase;

  setUp(() {
    mockRepository = MockDashboardRepository();
    useCase = GetFavouritesUseCase(mockRepository);
  });

  test('GetFavouritesUseCase returns favourite providers from repository',
      () async {
    final providers = [
      ProviderEntity(
        id: 'p1',
        firstName: 'Abhi',
        lastName: 'Test',
        email: 'a@test.com',
        phone: '9800',
        profession: 'Cleaner',
        serviceSlug: 'home-cleaning',
        avatarUrl: null,
        avgRating: 4.8,
        ratingCount: 20,
        completedJobs: 80,
        startingPrice: 500,
      ),
    ];

    when(() => mockRepository.getFavourites()).thenAnswer((_) async => providers);

    final result = await useCase();

    expect(result.length, 1);
    expect(result.first.id, 'p1');

    verify(() => mockRepository.getFavourites()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}