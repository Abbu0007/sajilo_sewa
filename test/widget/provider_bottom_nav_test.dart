import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_sewa/features/provider_dashboard/presentation/widgets/nav/provider_bottom_nav.dart';

void main() {
  testWidgets('provider bottom nav tap changes selected index',
      (tester) async {
    int selectedIndex = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: StatefulBuilder(
            builder: (context, setState) {
              return ProviderBottomNav(
                currentIndex: selectedIndex,
                onChanged: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.calendar_month_rounded));
    await tester.pump();

    expect(selectedIndex, 1);
  });
}