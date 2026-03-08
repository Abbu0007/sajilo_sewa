import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/widgets/home/home_header.dart';

void main() {
  testWidgets('home header shows title and subtitle', (tester) async {

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HomeHeader(
            title: 'Sajilo Sewa',
            subtitle: 'Find trusted services',
            unreadCount: 3,
            onTapNotifications: () {},
          ),
        ),
      ),
    );

    expect(find.text('Sajilo Sewa'), findsOneWidget);
    expect(find.text('Find trusted services'), findsOneWidget);
  });
}