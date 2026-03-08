import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_sewa/features/provider_dashboard/presentation/widgets/home/provider_welcome_header.dart';

void main() {
  testWidgets('provider welcome header shows provider name', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProviderWelcomeHeader(firstName: 'Abhi'),
        ),
      ),
    );

    expect(find.textContaining('Welcome, Abhi'), findsOneWidget);
  });
}