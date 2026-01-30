import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sajilo_sewa/features/profile/domain/entities/profile_entity.dart';
import 'package:sajilo_sewa/features/profile/presentation/pages/profile_screen.dart';
import 'package:sajilo_sewa/features/profile/presentation/providers/profile_providers.dart';

import 'profile_widget_test_helpers.dart';

void main() {
  testWidgets('ProfileScreen shows "Edit Profile" tile', (tester) async {
    final mockGet = MockGetProfileUseCase();

    final profile = ProfileEntity(
      id: "1",
      firstName: "Abhi",
      lastName: "Dhamala",
      email: "a@test.com",
      phone: "9800",
      role: "client",
      profession: null,
      avatarUrl: "",
    );

    when(() => mockGet.call()).thenAnswer((_) async => right(profile));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          getProfileUseCaseProvider.overrideWithValue(mockGet),
        ],
        child: const MaterialApp(home: ProfileScreen()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Edit Profile'), findsOneWidget);
  });
}
