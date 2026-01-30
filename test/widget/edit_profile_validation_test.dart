import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sajilo_sewa/features/profile/domain/entities/profile_entity.dart';
import 'package:sajilo_sewa/features/profile/presentation/pages/edit_profile_screen.dart';
import 'package:sajilo_sewa/features/profile/presentation/providers/profile_providers.dart';
import 'profile_widget_test_helpers.dart';

void main() {
  testWidgets('EditProfileScreen validates empty fields', (tester) async {
    final mockGet = MockGetProfileUseCase();

    final profile = ProfileEntity(
      id: "1",
      firstName: "",
      lastName: "",
      email: "",
      phone: "",
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
        child: const MaterialApp(home: EditProfileScreen()),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text("Save Changes"));
    await tester.pump();

    expect(find.text("First name is required"), findsOneWidget);
    expect(find.text("Last name is required"), findsOneWidget);
    expect(find.text("Phone number is required"), findsOneWidget);
  });
}
