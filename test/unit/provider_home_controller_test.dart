import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sajilo_sewa/features/provider_dashboard/domain/entities/provider_booking_entity.dart';
import 'package:sajilo_sewa/features/provider_dashboard/domain/entities/provider_me_entity.dart';
import 'package:sajilo_sewa/features/provider_dashboard/domain/usecases/get_provider_bookings_usecase.dart';
import 'package:sajilo_sewa/features/provider_dashboard/domain/usecases/get_provider_me_usecase.dart';
import 'package:sajilo_sewa/features/provider_dashboard/presentation/view_model/provider_home_controller.dart';

class MockGetProviderMeUseCase extends Mock implements GetProviderMeUseCase {}

class MockGetProviderBookingsUseCase extends Mock
    implements GetProviderBookingsUseCase {}

void main() {
  late MockGetProviderMeUseCase mockGetProviderMeUseCase;
  late MockGetProviderBookingsUseCase mockGetProviderBookingsUseCase;
  late ProviderHomeController controller;

  setUp(() {
    mockGetProviderMeUseCase = MockGetProviderMeUseCase();
    mockGetProviderBookingsUseCase = MockGetProviderBookingsUseCase();

    controller = ProviderHomeController(
      getMe: mockGetProviderMeUseCase,
      getBookings: mockGetProviderBookingsUseCase,
    );
  });

  testWidgets('provider home controller initial state is correct',
      (tester) async {
    await tester.pump();

    expect(controller.loading, false);
    expect(controller.error, null);
    expect(controller.me, null);
    expect(controller.bookings, isEmpty);
    expect(controller.countPending, 0);
    expect(controller.countConfirmed, 0);
    expect(controller.countInProgress, 0);
    expect(controller.countCompleted, 0);
  });

  testWidgets('provider home controller load updates counts correctly',
      (tester) async {
    const me = ProviderMeEntity(
      id: 'u1',
      firstName: 'Abhi',
      lastName: 'Dhamala',
      profession: 'Plumber',
    );

    final bookings = [
      const ProviderBookingEntity(
        id: 'b1',
        status: 'pending',
        scheduledAt: '2026-03-08',
      ),
      const ProviderBookingEntity(
        id: 'b2',
        status: 'confirmed',
        scheduledAt: '2026-03-08',
      ),
      const ProviderBookingEntity(
        id: 'b3',
        status: 'in_progress',
        scheduledAt: '2026-03-08',
      ),
      const ProviderBookingEntity(
        id: 'b4',
        status: 'completed',
        scheduledAt: '2026-03-08',
      ),
    ];

    when(() => mockGetProviderMeUseCase.call()).thenAnswer((_) async => me);
    when(() => mockGetProviderBookingsUseCase.call(status: 'all'))
        .thenAnswer((_) async => bookings);

    await controller.load();
    await tester.pump();

    expect(controller.loading, false);
    expect(controller.error, null);
    expect(controller.me?.id, 'u1');
    expect(controller.bookings.length, 4);
    expect(controller.countPending, 1);
    expect(controller.countConfirmed, 1);
    expect(controller.countInProgress, 1);
    expect(controller.countCompleted, 1);
  });

  testWidgets('provider home controller load sets error on failure',
      (tester) async {
    when(() => mockGetProviderMeUseCase.call())
        .thenThrow(Exception('Failed to load provider home'));

    await controller.load();
    await tester.pump();

    expect(controller.loading, false);
    expect(controller.error, 'Failed to load provider home');
  });
}