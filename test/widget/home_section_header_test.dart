import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/widgets/home/home_section_header.dart';

void main() {
  testWidgets('home section header action tap works', (tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HomeSectionHeader(
            title: 'Top Providers',
            actionText: 'See All',
            onAction: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Top Providers'), findsOneWidget);
    expect(find.text('See All'), findsOneWidget);

    await tester.tap(find.text('See All'));
    await tester.pump();

    expect(tapped, true);
  });
}