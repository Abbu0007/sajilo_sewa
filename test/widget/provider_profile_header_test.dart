import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_sewa/features/provider_dashboard/presentation/widgets/profile/provider_profile_header.dart';

void main() {
  testWidgets('provider profile header settings tap works', (tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProviderProfileHeader(
            name: 'Abhi Dhamala',
            profession: 'Plumber',
            phone: '9800000000',
            email: 'abhi@test.com',
            avatarUrl: null,
            onSettingsTap: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Abhi Dhamala'), findsOneWidget);
    expect(find.text('Plumber'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.settings));
    await tester.pump();

    expect(tapped, true);
  });
}