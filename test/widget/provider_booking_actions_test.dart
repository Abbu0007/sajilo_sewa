import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_sewa/features/provider_dashboard/domain/entities/provider_booking_entity.dart';
import 'package:sajilo_sewa/features/provider_dashboard/presentation/widgets/bookings/provider_booking_actions.dart';

void main() {
  testWidgets('provider booking actions render buttons', (tester) async {

    final booking = ProviderBookingEntity(
      id: 'b1',
      status: 'pending',
      scheduledAt: '2026-03-08T10:00:00.000Z',
      paymentStatus: null,
      price: null,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProviderBookingActions(
            booking: booking,
            busy: false,
            onAccept: () async {},
            onReject: (reason) async {},
            onMarkInProgress: () async {},
            onRequestPayment: (price, note) async {},
            onMarkCompleted: () async {},
            onCancel: (reason) async {},
          ),
        ),
      ),
    );

    expect(find.byType(ProviderBookingActions), findsOneWidget);
    expect(find.byType(ElevatedButton), findsWidgets);
  });
}