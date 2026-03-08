import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_sewa/features/provider_dashboard/presentation/widgets/profile/provider_profile_tile.dart';

void main() {
  testWidgets('provider profile tile tap works', (tester) async {
    bool tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProviderProfileTile(
            iconBg: Colors.blue.shade100,
            icon: Icons.person,
            iconColor: Colors.blue,
            title: 'Edit Profile',
            trailingText: 'Open',
            onTap: () {
              tapped = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Edit Profile'), findsOneWidget);
    expect(find.text('Open'), findsOneWidget);

    await tester.tap(find.text('Edit Profile'));
    await tester.pump();

    expect(tapped, true);
  });
}