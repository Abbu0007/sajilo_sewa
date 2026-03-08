import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sajilo_sewa/features/dashboard/domain/entities/booking_entity.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/cancel_booking_usecase.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/confirm_payment_usecase.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/get_my_bookings_usecase.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/view_model/bookings_controller.dart';

class MockGetMyBookingsUseCase extends Mock implements GetMyBookingsUseCase {}

class MockCancelBookingUseCase extends Mock implements CancelBookingUseCase {}

class MockConfirmPaymentUseCase extends Mock
    implements ConfirmPaymentUseCase {}

void main() {
  late MockGetMyBookingsUseCase mockGetMyBookingsUseCase;
  late MockCancelBookingUseCase mockCancelBookingUseCase;
  late MockConfirmPaymentUseCase mockConfirmPaymentUseCase;
  late BookingsController controller;

  setUp(() {
    mockGetMyBookingsUseCase = MockGetMyBookingsUseCase();
    mockCancelBookingUseCase = MockCancelBookingUseCase();
    mockConfirmPaymentUseCase = MockConfirmPaymentUseCase();

    controller = BookingsController(
      getMyBookings: mockGetMyBookingsUseCase,
      cancelBooking: mockCancelBookingUseCase,
      confirmPayment: mockConfirmPaymentUseCase,
    );
  });

  testWidgets('bookings controller initial state is correct', (tester) async {
    expect(controller.loading, false);
    expect(controller.error, null);
    expect(controller.status, 'all');
    expect(controller.items, isEmpty);
  });

  testWidgets('bookings controller load updates items successfully',
      (tester) async {
    final bookings = [
      const BookingEntity(
        id: 'b1',
        status: 'pending',
        scheduledAt: '2026-03-08T10:00:00.000Z',
      ),
      const BookingEntity(
        id: 'b2',
        status: 'completed',
        scheduledAt: '2026-03-09T12:00:00.000Z',
      ),
    ];

    when(() => mockGetMyBookingsUseCase.call(status: any(named: 'status')))
        .thenAnswer((_) async => bookings);

    await controller.load();

    expect(controller.loading, false);
    expect(controller.error, null);
    expect(controller.items.length, 2);
    expect(controller.items.first.id, 'b1');
    expect(controller.status, 'all');

    verify(() => mockGetMyBookingsUseCase.call(status: 'all')).called(1);
  });

  testWidgets('bookings controller load changes status when newStatus is passed',
      (tester) async {
    when(() => mockGetMyBookingsUseCase.call(status: any(named: 'status')))
        .thenAnswer((_) async => []);

    await controller.load(newStatus: 'completed');

    expect(controller.status, 'completed');
    expect(controller.loading, false);
    expect(controller.items, isEmpty);

    verify(() => mockGetMyBookingsUseCase.call(status: 'completed')).called(1);
  });

  testWidgets('bookings controller load sets error on failure', (tester) async {
    when(() => mockGetMyBookingsUseCase.call(status: any(named: 'status')))
        .thenThrow(Exception('Failed to load bookings'));

    await controller.load();

    expect(controller.loading, false);
    expect(controller.error, 'Failed to load bookings');
    expect(controller.items, isEmpty);
  });

  testWidgets('bookings controller doCancel calls usecase and reloads list',
      (tester) async {
    when(() => mockCancelBookingUseCase.call('b1', reason: 'Not available'))
        .thenAnswer((_) async {});
    when(() => mockGetMyBookingsUseCase.call(status: any(named: 'status')))
        .thenAnswer((_) async => []);

    await controller.doCancel('b1', reason: 'Not available');

    verify(() => mockCancelBookingUseCase.call('b1', reason: 'Not available'))
        .called(1);
    verify(() => mockGetMyBookingsUseCase.call(status: 'all')).called(1);

    expect(controller.error, null);
    expect(controller.loading, false);
  });

  testWidgets(
      'bookings controller doConfirmPayment calls usecase and reloads list',
      (tester) async {
    when(() => mockConfirmPaymentUseCase.call('b1')).thenAnswer((_) async {});
    when(() => mockGetMyBookingsUseCase.call(status: any(named: 'status')))
        .thenAnswer((_) async => []);

    await controller.doConfirmPayment('b1');

    verify(() => mockConfirmPaymentUseCase.call('b1')).called(1);
    verify(() => mockGetMyBookingsUseCase.call(status: 'all')).called(1);

    expect(controller.error, null);
    expect(controller.loading, false);
  });

  testWidgets('bookings controller canCancel returns true for pending booking',
      (tester) async {
    const booking = BookingEntity(
      id: 'b1',
      status: 'pending',
      scheduledAt: '2026-03-08T10:00:00.000Z',
    );

    expect(controller.canCancel(booking), true);
  });

  testWidgets('bookings controller canCancel returns true for confirmed booking',
      (tester) async {
    const booking = BookingEntity(
      id: 'b1',
      status: 'confirmed',
      scheduledAt: '2026-03-08T10:00:00.000Z',
    );

    expect(controller.canCancel(booking), true);
  });

  testWidgets(
      'bookings controller canConfirmPayment returns true for awaiting payment',
      (tester) async {
    const booking = BookingEntity(
      id: 'b1',
      status: 'awaiting_payment_confirmation',
      scheduledAt: '2026-03-08T10:00:00.000Z',
    );

    expect(controller.canConfirmPayment(booking), true);
  });

  testWidgets('bookings controller isCompleted returns true for completed booking',
      (tester) async {
    const booking = BookingEntity(
      id: 'b1',
      status: 'completed',
      scheduledAt: '2026-03-08T10:00:00.000Z',
    );

    expect(controller.isCompleted(booking), true);
  });

  testWidgets('bookings controller isCancelled returns true for cancelled booking',
      (tester) async {
    const booking = BookingEntity(
      id: 'b1',
      status: 'cancelled',
      scheduledAt: '2026-03-08T10:00:00.000Z',
    );

    expect(controller.isCancelled(booking), true);
  });
}