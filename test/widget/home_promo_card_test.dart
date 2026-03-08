import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/widgets/home/home_promo_card.dart';

void main() {
  testWidgets('home promo card renders title and subtitle', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: HomePromoCard(
            title: 'Special Offer',
            subtitle: 'Get trusted home services quickly',
          ),
        ),
      ),
    );

    expect(find.text('Special Offer'), findsOneWidget);
    expect(find.text('Get trusted home services quickly'), findsOneWidget);
  });
}