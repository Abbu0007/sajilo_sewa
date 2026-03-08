import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sajilo_sewa/features/dashboard/domain/entities/provider_entity.dart';
import 'package:sajilo_sewa/features/dashboard/domain/entities/service_entity.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/get_service_usecase.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/get_top_rated_providers_usecase.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/view_model/dashboard_home_controller.dart';

class MockGetServicesUseCase extends Mock implements GetServicesUseCase {}

class MockGetTopRatedProvidersUseCase extends Mock
    implements GetTopRatedProvidersUseCase {}

void main() {
  late MockGetServicesUseCase mockGetServicesUseCase;
  late MockGetTopRatedProvidersUseCase mockGetTopRatedProvidersUseCase;
  late DashboardHomeController controller;

  setUp(() {
    mockGetServicesUseCase = MockGetServicesUseCase();
    mockGetTopRatedProvidersUseCase = MockGetTopRatedProvidersUseCase();

    controller = DashboardHomeController(
      getServices: mockGetServicesUseCase,
      getTopRatedProviders: mockGetTopRatedProvidersUseCase,
    );
  });

  testWidgets('dashboard home controller initial state is correct',
      (tester) async {
    await tester.pump();

    expect(controller.loading, false);
    expect(controller.error, null);
    expect(controller.services, isEmpty);
    expect(controller.topRated, isEmpty);
    expect(controller.serviceIdBySlug, isEmpty);
  });

  testWidgets('dashboard home controller load updates services and providers',
      (tester) async {
    final services = [
      const ServiceEntity(id: 's1', name: 'Cleaning', slug: 'home-cleaning'),
      const ServiceEntity(id: 's2', name: 'Plumbing', slug: 'plumbing'),
    ];

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
        ratingCount: 20,
        completedJobs: 100,
        startingPrice: 500,
      ),
    ];

    when(() => mockGetServicesUseCase.call()).thenAnswer((_) async => services);
    when(() => mockGetTopRatedProvidersUseCase.call(limit: 8))
        .thenAnswer((_) async => providers);

    await controller.load();
    await tester.pump();

    expect(controller.loading, false);
    expect(controller.error, null);
    expect(controller.services.length, 2);
    expect(controller.topRated.length, 1);
    expect(controller.serviceIdBySlug['home-cleaning'], 's1');
    expect(controller.serviceIdBySlug['plumbing'], 's2');

    verify(() => mockGetServicesUseCase.call()).called(1);
    verify(() => mockGetTopRatedProvidersUseCase.call(limit: 8)).called(1);
  });

  testWidgets('dashboard home controller homeServices returns first 6 only',
      (tester) async {
    controller.services = const [
      ServiceEntity(id: '1', name: 'A', slug: 'a'),
      ServiceEntity(id: '2', name: 'B', slug: 'b'),
      ServiceEntity(id: '3', name: 'C', slug: 'c'),
      ServiceEntity(id: '4', name: 'D', slug: 'd'),
      ServiceEntity(id: '5', name: 'E', slug: 'e'),
      ServiceEntity(id: '6', name: 'F', slug: 'f'),
      ServiceEntity(id: '7', name: 'G', slug: 'g'),
    ];

    await tester.pump();

    expect(controller.homeServices.length, 6);
    expect(controller.homeServices.first.id, '1');
    expect(controller.homeServices.last.id, '6');
  });

  testWidgets('dashboard home controller getServiceIdFromSlug works correctly',
      (tester) async {
    controller.serviceIdBySlug['home-cleaning'] = 's1';

    await tester.pump();

    expect(controller.getServiceIdFromSlug('home-cleaning'), 's1');
    expect(controller.getServiceIdFromSlug(''), null);
    expect(controller.getServiceIdFromSlug(null), null);
  });

  testWidgets('dashboard home controller load sets error on failure',
      (tester) async {
    when(() => mockGetServicesUseCase.call())
        .thenThrow(Exception('Failed to load home data'));

    await controller.load();
    await tester.pump();

    expect(controller.loading, false);
    expect(controller.error, 'Failed to load home data');
  });
}