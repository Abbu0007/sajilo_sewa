import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/widgets/home/home_services_grid.dart';
void main() {
  testWidgets('home services grid renders items', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HomeServicesGrid(
            itemCount: 2,
            itemBuilder: (index) {
              return Text('Item $index');
            },
          ),
        ),
      ),
    );

    expect(find.byType(GridView), findsOneWidget);
    expect(find.text('Item 0'), findsOneWidget);
    expect(find.text('Item 1'), findsOneWidget);
  });
}