import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sajilo_sewa/features/provider_dashboard/domain/entities/provider_booking_entity.dart';
import 'package:sajilo_sewa/features/provider_dashboard/domain/usecases/accept_booking_usecase.dart';
import 'package:sajilo_sewa/features/provider_dashboard/domain/usecases/create_rating_usecase.dart';
import 'package:sajilo_sewa/features/provider_dashboard/domain/usecases/get_provider_bookings_usecase.dart';
import 'package:sajilo_sewa/features/provider_dashboard/domain/usecases/reject_booking_usecase.dart';
import 'package:sajilo_sewa/features/provider_dashboard/domain/usecases/update_booking_status_usecase.dart';
import 'package:sajilo_sewa/features/provider_dashboard/presentation/view_model/provider_bookings_controller.dart';

class MockGetProviderBookingsUseCase extends Mock
    implements GetProviderBookingsUseCase {}

class MockAcceptBookingUseCase extends Mock implements AcceptBookingUseCase {}

class MockRejectBookingUseCase extends Mock implements RejectBookingUseCase {}

class MockUpdateBookingStatusUseCase extends Mock
    implements UpdateBookingStatusUseCase {}

class MockCreateRatingUseCase extends Mock implements CreateRatingUseCase {}

void main() {
  late MockGetProviderBookingsUseCase mockGetProviderBookingsUseCase;
  late MockAcceptBookingUseCase mockAcceptBookingUseCase;
  late MockRejectBookingUseCase mockRejectBookingUseCase;
  late MockUpdateBookingStatusUseCase mockUpdateBookingStatusUseCase;
  late MockCreateRatingUseCase mockCreateRatingUseCase;
  late ProviderBookingsController controller;

  ProviderBookingEntity buildBooking({
    String id = 'b1',
    String status = 'pending',
    String scheduledAt = '2026-03-08T10:00:00.000Z',
    String? paymentStatus,
    num? price,
  }) {
    return ProviderBookingEntity(
      id: id,
      status: status,
      scheduledAt: scheduledAt,
      paymentStatus: paymentStatus,
      price: price,
    );
  }

  setUp(() {
    mockGetProviderBookingsUseCase = MockGetProviderBookingsUseCase();
    mockAcceptBookingUseCase = MockAcceptBookingUseCase();
    mockRejectBookingUseCase = MockRejectBookingUseCase();
    mockUpdateBookingStatusUseCase = MockUpdateBookingStatusUseCase();
    mockCreateRatingUseCase = MockCreateRatingUseCase();

    controller = ProviderBookingsController(
      getBookings: mockGetProviderBookingsUseCase,
      accept: mockAcceptBookingUseCase,
      reject: mockRejectBookingUseCase,
      updateStatus: mockUpdateBookingStatusUseCase,
      createRating: mockCreateRatingUseCase,
    );
  });

  testWidgets('provider bookings controller initial state is correct',
      (tester) async {
    await tester.pump();

    expect(controller.loading, false);
    expect(controller.actionBusy, false);
    expect(controller.error, null);
    expect(controller.items, isEmpty);
    expect(controller.status, 'all');
  });

  testWidgets('provider bookings controller load updates items',
      (tester) async {
    final bookings = [
      buildBooking(id: 'b1', status: 'pending'),
      buildBooking(id: 'b2', status: 'confirmed'),
    ];

    when(() => mockGetProviderBookingsUseCase.call(status: 'all'))
        .thenAnswer((_) async => bookings);

    await controller.load();
    await tester.pump();

    expect(controller.loading, false);
    expect(controller.error, null);
    expect(controller.items.length, 2);
    expect(controller.items.first.id, 'b1');
    expect(controller.status, 'all');

    verify(() => mockGetProviderBookingsUseCase.call(status: 'all')).called(1);
  });

  testWidgets('provider bookings controller load changes status filter',
      (tester) async {
    when(() => mockGetProviderBookingsUseCase.call(status: 'pending'))
        .thenAnswer((_) async => [buildBooking(status: 'pending')]);

    await controller.load(status: 'pending');
    await tester.pump();

    expect(controller.status, 'pending');
    expect(controller.items.length, 1);
    expect(controller.items.first.status, 'pending');

    verify(() => mockGetProviderBookingsUseCase.call(status: 'pending'))
        .called(1);
  });

  testWidgets('provider bookings controller load sets error on failure',
      (tester) async {
    when(() => mockGetProviderBookingsUseCase.call(status: 'all'))
        .thenThrow(Exception('Failed to load provider bookings'));

    await controller.load();
    await tester.pump();

    expect(controller.loading, false);
    expect(controller.error, 'Failed to load provider bookings');
    expect(controller.items, isEmpty);
  });

  testWidgets('provider bookings controller acceptBooking works',
      (tester) async {
    when(() => mockAcceptBookingUseCase.call('b1'))
        .thenAnswer((_) async => buildBooking(id: 'b1', status: 'confirmed'));
    when(() => mockGetProviderBookingsUseCase.call(status: 'all'))
        .thenAnswer((_) async => [buildBooking(id: 'b1', status: 'confirmed')]);

    await controller.acceptBooking('b1');
    await tester.pump();

    verify(() => mockAcceptBookingUseCase.call('b1')).called(1);
    verify(() => mockGetProviderBookingsUseCase.call(status: 'all')).called(1);

    expect(controller.actionBusy, false);
    expect(controller.error, null);
  });

  testWidgets('provider bookings controller rejectBooking works',
      (tester) async {
    when(() => mockRejectBookingUseCase.call('b1', reason: 'Busy')).thenAnswer(
      (_) async => buildBooking(id: 'b1', status: 'cancelled'),
    );
    when(() => mockGetProviderBookingsUseCase.call(status: 'all'))
        .thenAnswer((_) async => []);

    await controller.rejectBooking('b1', reason: 'Busy');
    await tester.pump();

    verify(() => mockRejectBookingUseCase.call('b1', reason: 'Busy')).called(1);
    verify(() => mockGetProviderBookingsUseCase.call(status: 'all')).called(1);

    expect(controller.actionBusy, false);
    expect(controller.error, null);
  });

  testWidgets('provider bookings controller markInProgress works',
      (tester) async {
    when(() => mockUpdateBookingStatusUseCase.call(
          'b1',
          status: 'in_progress',
        )).thenAnswer(
      (_) async => buildBooking(id: 'b1', status: 'in_progress'),
    );
    when(() => mockGetProviderBookingsUseCase.call(status: 'all')).thenAnswer(
      (_) async => [buildBooking(id: 'b1', status: 'in_progress')],
    );

    await controller.markInProgress('b1');
    await tester.pump();

    verify(() => mockUpdateBookingStatusUseCase.call(
          'b1',
          status: 'in_progress',
        )).called(1);
    verify(() => mockGetProviderBookingsUseCase.call(status: 'all')).called(1);

    expect(controller.actionBusy, false);
    expect(controller.error, null);
  });

  testWidgets('provider bookings controller requestPayment works',
      (tester) async {
    when(() => mockUpdateBookingStatusUseCase.call(
          'b1',
          status: 'awaiting_payment_confirmation',
          reason: 'Work done',
          price: 1500,
        )).thenAnswer(
      (_) async => buildBooking(
        id: 'b1',
        status: 'awaiting_payment_confirmation',
        price: 1500,
      ),
    );
    when(() => mockGetProviderBookingsUseCase.call(status: 'all')).thenAnswer(
      (_) async => [
        buildBooking(
          id: 'b1',
          status: 'awaiting_payment_confirmation',
          price: 1500,
        ),
      ],
    );

    await controller.requestPayment(
      'b1',
      price: 1500,
      reason: 'Work done',
    );
    await tester.pump();

    verify(() => mockUpdateBookingStatusUseCase.call(
          'b1',
          status: 'awaiting_payment_confirmation',
          reason: 'Work done',
          price: 1500,
        )).called(1);
    verify(() => mockGetProviderBookingsUseCase.call(status: 'all')).called(1);

    expect(controller.actionBusy, false);
    expect(controller.error, null);
  });

  testWidgets('provider bookings controller markCompleted works',
      (tester) async {
    when(() => mockUpdateBookingStatusUseCase.call(
          'b1',
          status: 'completed',
        )).thenAnswer(
      (_) async => buildBooking(id: 'b1', status: 'completed'),
    );
    when(() => mockGetProviderBookingsUseCase.call(status: 'all')).thenAnswer(
      (_) async => [buildBooking(id: 'b1', status: 'completed')],
    );

    await controller.markCompleted('b1');
    await tester.pump();

    verify(() => mockUpdateBookingStatusUseCase.call(
          'b1',
          status: 'completed',
        )).called(1);
    verify(() => mockGetProviderBookingsUseCase.call(status: 'all')).called(1);

    expect(controller.actionBusy, false);
    expect(controller.error, null);
  });

  testWidgets('provider bookings controller cancelBooking works',
      (tester) async {
    when(() => mockUpdateBookingStatusUseCase.call(
          'b1',
          status: 'cancelled',
          reason: 'Emergency',
        )).thenAnswer(
      (_) async => buildBooking(id: 'b1', status: 'cancelled'),
    );
    when(() => mockGetProviderBookingsUseCase.call(status: 'all'))
        .thenAnswer((_) async => []);

    await controller.cancelBooking('b1', reason: 'Emergency');
    await tester.pump();

    verify(() => mockUpdateBookingStatusUseCase.call(
          'b1',
          status: 'cancelled',
          reason: 'Emergency',
        )).called(1);
    verify(() => mockGetProviderBookingsUseCase.call(status: 'all')).called(1);

    expect(controller.actionBusy, false);
    expect(controller.error, null);
  });

  testWidgets('provider bookings controller rate works', (tester) async {
    when(() => mockCreateRatingUseCase.call(
          bookingId: 'b1',
          stars: 5,
          comment: 'Great client',
        )).thenAnswer((_) async {});

    await controller.rate(
      bookingId: 'b1',
      stars: 5,
      comment: 'Great client',
    );
    await tester.pump();

    verify(() => mockCreateRatingUseCase.call(
          bookingId: 'b1',
          stars: 5,
          comment: 'Great client',
        )).called(1);

    expect(controller.actionBusy, false);
    expect(controller.error, null);
  });

  testWidgets('provider bookings controller action sets error on failure',
      (tester) async {
    when(() => mockAcceptBookingUseCase.call('b1'))
        .thenThrow(Exception('Accept failed'));

    await controller.acceptBooking('b1');
    await tester.pump();

    expect(controller.actionBusy, false);
    expect(controller.error, 'Accept failed');
  });
}