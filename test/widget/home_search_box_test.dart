import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/widgets/home/home_search_box.dart';

void main() {
  testWidgets('home search box renders with hint', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HomeSearchBox(
            hint: 'Search providers',
            onChanged: (_) {},
          ),
        ),
      ),
    );

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Search providers'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });
}