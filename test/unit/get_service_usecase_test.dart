import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sajilo_sewa/features/dashboard/domain/entities/service_entity.dart';
import 'package:sajilo_sewa/features/dashboard/domain/repositories/i_dashboard_repository.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/get_service_usecase.dart';

class MockDashboardRepository extends Mock implements IDashboardRepository {}

void main() {
  late MockDashboardRepository mockRepository;
  late GetServicesUseCase useCase;

  setUp(() {
    mockRepository = MockDashboardRepository();
    useCase = GetServicesUseCase(mockRepository);
  });

  test('GetServicesUseCase returns list of services from repository', () async {
    const services = [
      ServiceEntity(
        id: 's1',
        name: 'Home Cleaning',
        slug: 'home-cleaning',
      ),
      ServiceEntity(
        id: 's2',
        name: 'Plumbing',
        slug: 'plumbing',
      ),
    ];

    when(() => mockRepository.getServices()).thenAnswer((_) async => services);

    final result = await useCase();

    expect(result.length, 2);
    expect(result.first.name, 'Home Cleaning');
    expect(result.last.slug, 'plumbing');

    verify(() => mockRepository.getServices()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}