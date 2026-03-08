import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sajilo_sewa/features/dashboard/domain/entities/provider_entity.dart';
import 'package:sajilo_sewa/features/dashboard/domain/entities/service_entity.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/get_favourites_usecase.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/get_service_usecase.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/toggle_favourite_usecase.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/view_model/favourites_controller.dart';

class MockGetFavouritesUseCase extends Mock implements GetFavouritesUseCase {}

class MockGetServicesUseCase extends Mock implements GetServicesUseCase {}

class MockToggleFavouriteUseCase extends Mock implements ToggleFavouriteUseCase {}

void main() {
  late MockGetFavouritesUseCase mockGetFavouritesUseCase;
  late MockGetServicesUseCase mockGetServicesUseCase;
  late MockToggleFavouriteUseCase mockToggleFavouriteUseCase;
  late FavouritesController controller;

  ProviderEntity buildProvider({
    required String id,
    required String slug,
  }) {
    return ProviderEntity(
      id: id,
      firstName: 'Abhi',
      lastName: 'Test',
      email: 'a@test.com',
      phone: '9800',
      profession: 'Cleaner',
      serviceSlug: slug,
      avatarUrl: null,
      avgRating: 4.5,
      ratingCount: 10,
      completedJobs: 30,
      startingPrice: 500,
    );
  }

  setUp(() {
    mockGetFavouritesUseCase = MockGetFavouritesUseCase();
    mockGetServicesUseCase = MockGetServicesUseCase();
    mockToggleFavouriteUseCase = MockToggleFavouriteUseCase();

    controller = FavouritesController(
      getFavourites: mockGetFavouritesUseCase,
      getServices: mockGetServicesUseCase,
      toggleFavourite: mockToggleFavouriteUseCase,
    );
  });

  testWidgets('favourites controller initial state is correct', (tester) async {
    await tester.pump();

    expect(controller.loading, false);
    expect(controller.error, null);
    expect(controller.items, isEmpty);
    expect(controller.favIds, isEmpty);
    expect(controller.serviceIdBySlug, isEmpty);
  });

  testWidgets('favourites controller load updates items and favIds',
      (tester) async {
    final services = const [
      ServiceEntity(id: 's1', name: 'Cleaning', slug: 'home-cleaning'),
    ];
    final providers = [
      buildProvider(id: 'p1', slug: 'home-cleaning'),
    ];

    when(() => mockGetServicesUseCase.call()).thenAnswer((_) async => services);
    when(() => mockGetFavouritesUseCase.call())
        .thenAnswer((_) async => providers);

    await controller.load();
    await tester.pump();

    expect(controller.loading, false);
    expect(controller.error, null);
    expect(controller.items.length, 1);
    expect(controller.isFavourite('p1'), true);
    expect(controller.serviceIdBySlug['home-cleaning'], 's1');
  });

  testWidgets('favourites controller serviceIdForProvider returns mapped id',
      (tester) async {
    final provider = buildProvider(id: 'p1', slug: 'home-cleaning');
    controller.serviceIdBySlug['home-cleaning'] = 's1';

    await tester.pump();

    expect(controller.serviceIdForProvider(provider), 's1');
  });

  testWidgets('favourites controller toggle removes favourite when backend false',
      (tester) async {
    final provider = buildProvider(id: 'p1', slug: 'home-cleaning');
    controller.items = [provider];
    controller.favIds.add('p1');

    when(() => mockToggleFavouriteUseCase.call('p1'))
        .thenAnswer((_) async => false);

    await controller.toggle('p1');
    await tester.pump();

    expect(controller.isFavourite('p1'), false);
    expect(controller.items.where((e) => e.id == 'p1'), isEmpty);
  });

  testWidgets('favourites controller toggle adds favourite and reloads on true',
      (tester) async {
    final provider = buildProvider(id: 'p1', slug: 'home-cleaning');

    when(() => mockToggleFavouriteUseCase.call('p1'))
        .thenAnswer((_) async => true);
    when(() => mockGetServicesUseCase.call()).thenAnswer(
      (_) async => const [
        ServiceEntity(id: 's1', name: 'Cleaning', slug: 'home-cleaning'),
      ],
    );
    when(() => mockGetFavouritesUseCase.call())
        .thenAnswer((_) async => [provider]);

    await controller.toggle('p1');
    await tester.pump();

    expect(controller.isFavourite('p1'), true);
    expect(controller.items.length, 1);
  });

  testWidgets('favourites controller toggle rolls back and sets error on failure',
      (tester) async {
    when(() => mockToggleFavouriteUseCase.call('p1'))
        .thenThrow(Exception('Toggle failed'));

    await controller.toggle('p1');
    await tester.pump();

    expect(controller.isFavourite('p1'), false);
    expect(controller.error, 'Toggle failed');
  });
}