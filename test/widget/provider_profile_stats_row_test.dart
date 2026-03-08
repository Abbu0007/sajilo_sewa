import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_sewa/features/provider_dashboard/presentation/widgets/profile/provider_profile_stats_row.dart';

void main() {
  testWidgets('provider profile stats row renders all stats', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProviderProfileStatsRow(
            bookings: '25',
            rating: '4.8',
            earnings: 'Rs. 12000',
          ),
        ),
      ),
    );

    expect(find.text('25'), findsOneWidget);
    expect(find.text('4.8'), findsOneWidget);
    expect(find.text('Rs. 12000'), findsOneWidget);
    expect(find.text('Completed Jobs'), findsOneWidget);
    expect(find.text('Rating'), findsOneWidget);
    expect(find.text('Total Earnings'), findsOneWidget);
  });
}