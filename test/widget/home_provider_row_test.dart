import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/widgets/home/home_provider_row.dart';

void main() {
  testWidgets('home provider row tap works', (tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HomeProviderRow(
            name: 'Ram Sharma',
            profession: 'Plumber',
            avatarUrl: null,
            avgRating: 4.5,
            ratingCount: 12,
            completedJobs: 40,
            startingPrice: 700,
            onTap: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Ram Sharma'), findsOneWidget);
    expect(find.text('Plumber'), findsOneWidget);
    expect(find.text('40 jobs'), findsOneWidget);
    expect(find.text('From Rs. 700'), findsOneWidget);

    await tester.tap(find.text('Ram Sharma'));
    await tester.pump();

    expect(tapped, true);
  });
}