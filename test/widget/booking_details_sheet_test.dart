import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_sewa/features/dashboard/domain/entities/booking_entity.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/widgets/bookings/booking_details_sheet.dart';

void main() {
  testWidgets('booking details sheet renders booking info', (tester) async {
    const booking = BookingEntity(
      id: 'b1',
      status: 'pending',
      scheduledAt: '2026-03-08T10:00:00.000Z',
      paymentStatus: 'pending',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: BookingDetailsSheet(
              booking: booking,
              onCancel: (id, reason) async {},
              onConfirmPayment: (id) async {},
            ),
          ),
        ),
      ),
    );

    expect(find.byType(BookingDetailsSheet), findsOneWidget);
    expect(find.textContaining('pending'), findsWidgets);
  });
}