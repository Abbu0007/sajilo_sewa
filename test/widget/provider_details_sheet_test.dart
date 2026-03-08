import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_sewa/features/dashboard/domain/entities/provider_entity.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/widgets/service/provider_card.dart';

void main() {
  testWidgets('provider card buttons and favourite tap work', (tester) async {
    bool detailsTapped = false;
    bool bookTapped = false;
    bool favouriteTapped = false;

    final provider = ProviderEntity(
      id: 'p1',
      firstName: 'Ram',
      lastName: 'Sharma',
      email: 'ram@test.com',
      phone: '9800000000',
      profession: 'Plumber',
      serviceSlug: 'plumbing',
      avatarUrl: null,
      avgRating: 4.5,
      ratingCount: 12,
      completedJobs: 20,
      startingPrice: 700,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ProviderCard(
            provider: provider,
            isFavourite: false,
            onViewDetails: () {
              detailsTapped = true;
            },
            onBookNow: () {
              bookTapped = true;
            },
            onFavourite: () {
              favouriteTapped = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Ram Sharma'), findsOneWidget);
    expect(find.text('Plumber'), findsOneWidget);
    expect(find.text('View Details'), findsOneWidget);
    expect(find.text('Book Now'), findsOneWidget);
    expect(find.text('20 jobs'), findsOneWidget);
    expect(find.text('From Rs. 700'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pump();
    expect(favouriteTapped, true);

    await tester.tap(find.text('View Details'));
    await tester.pump();
    expect(detailsTapped, true);

    await tester.tap(find.text('Book Now'));
    await tester.pump();
    expect(bookTapped, true);
  });
}