import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sajilo_sewa/features/dashboard/domain/entities/provider_entity.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/get_providers_by_service_usecase.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/view_model/service_providers_controller.dart';

class MockGetProvidersByServiceUseCase extends Mock
    implements GetProvidersByServiceUseCase {}

void main() {
  late MockGetProvidersByServiceUseCase mockGetProvidersByServiceUseCase;
  late ServiceProvidersController controller;

  setUp(() {
    mockGetProvidersByServiceUseCase = MockGetProvidersByServiceUseCase();

    controller = ServiceProvidersController(
      getProviders: mockGetProvidersByServiceUseCase,
    );
  });

  testWidgets('service providers controller initial state is correct',
      (tester) async {
    await tester.pump();

    expect(controller.loading, false);
    expect(controller.error, null);
    expect(controller.providers, isEmpty);
  });

  testWidgets('service providers controller load updates providers',
      (tester) async {
    final providers = [
      ProviderEntity(
        id: 'p1',
        firstName: 'Ram',
        lastName: 'Sharma',
        email: 'ram@test.com',
        phone: '9800',
        profession: 'Cleaner',
        serviceSlug: 'home-cleaning',
        avatarUrl: null,
        avgRating: 4.8,
        ratingCount: 10,
        completedJobs: 45,
        startingPrice: 500,
      ),
    ];

    when(() => mockGetProvidersByServiceUseCase.call('home-cleaning'))
        .thenAnswer((_) async => providers);

    await controller.load('home-cleaning');
    await tester.pump();

    expect(controller.loading, false);
    expect(controller.error, null);
    expect(controller.providers.length, 1);
    expect(controller.providers.first.id, 'p1');
  });

  testWidgets('service providers controller load sets error on failure',
      (tester) async {
    when(() => mockGetProvidersByServiceUseCase.call('home-cleaning'))
        .thenThrow(Exception('Failed to load providers'));

    await controller.load('home-cleaning');
    await tester.pump();

    expect(controller.loading, false);
    expect(controller.error, 'Failed to load providers');
    expect(controller.providers, isEmpty);
  });
}