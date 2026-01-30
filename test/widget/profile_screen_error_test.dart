import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sajilo_sewa/core/error/failures.dart';
import 'package:sajilo_sewa/features/profile/presentation/pages/profile_screen.dart';
import 'package:sajilo_sewa/features/profile/presentation/providers/profile_providers.dart';
import 'profile_widget_test_helpers.dart';

void main() {
  testWidgets('ProfileScreen shows error message', (tester) async {
    final mockGet = MockGetProfileUseCase();

    when(() => mockGet.call())
        .thenAnswer((_) async => left(ServerFailure(message: "Server error")));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          getProfileUseCaseProvider.overrideWithValue(mockGet),
        ],
        child: const MaterialApp(home: ProfileScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text("Server error"), findsOneWidget);
  });
}
