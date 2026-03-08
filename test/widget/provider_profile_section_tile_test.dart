import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_sewa/features/provider_dashboard/presentation/widgets/profile/provider_profile_section_tile.dart';

void main() {
  testWidgets('provider profile section title renders', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProviderProfileSectionTitle(title: 'Account'),
        ),
      ),
    );

    expect(find.text('Account'), findsOneWidget);
  });
}