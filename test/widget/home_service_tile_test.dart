import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/widgets/home/home_service_tile.dart';

void main() {
  testWidgets('home service tile tap works', (tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HomeServiceTile(
            name: 'Home Cleaning',
            slug: 'home-cleaning',
            priceFrom: 500,
            onTap: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Home Cleaning'), findsOneWidget);
    expect(find.text('From Rs. 500'), findsOneWidget);

    await tester.tap(find.text('Home Cleaning'));
    await tester.pump();

    expect(tapped, true);
  });
}