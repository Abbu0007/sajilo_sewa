import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/widgets/ratings/rating_sheet.dart';

void main() {
  testWidgets('rating sheet renders and submit tap works', (tester) async {
    bool submitted = false;
    int? submittedStars;
    String? submittedComment;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: RatingSheet(
            title: 'Rate Provider',
            subtitle: 'Share your experience',
            onSubmit: (stars, comment) async {
              submitted = true;
              submittedStars = stars;
              submittedComment = comment;
            },
          ),
        ),
      ),
    );

    expect(find.text('Rate Provider'), findsOneWidget);
    expect(find.text('Share your experience'), findsOneWidget);
    expect(find.text('Submit Rating'), findsOneWidget);

    await tester.tap(find.text('Submit Rating'));
    await tester.pump();

    expect(submitted, true);
    expect(submittedStars, 5);
    expect(submittedComment, null);
  });
}