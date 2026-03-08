import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_sewa/features/provider_dashboard/presentation/widgets/profile/provider_profile_tile_switch.dart';

void main() {
  testWidgets('provider profile tile switch toggles', (tester) async {
    bool switchValue = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return ProviderProfileTileSwitch(
                iconBg: Colors.blue.shade100,
                icon: Icons.notifications,
                iconColor: Colors.blue,
                title: 'Notifications',
                value: switchValue,
                onChanged: (value) {
                  setState(() {
                    switchValue = value;
                  });
                },
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('Notifications'), findsOneWidget);

    await tester.tap(find.byType(Switch));
    await tester.pump();

    expect(switchValue, true);
  });
}