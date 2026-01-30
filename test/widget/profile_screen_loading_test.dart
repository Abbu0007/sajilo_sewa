import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sajilo_sewa/core/error/failures.dart';
import 'package:sajilo_sewa/features/profile/domain/entities/profile_entity.dart';
import 'package:sajilo_sewa/features/profile/presentation/pages/profile_screen.dart';
import 'package:sajilo_sewa/features/profile/presentation/providers/profile_providers.dart';

import 'profile_widget_test_helpers.dart';

void main() {
  testWidgets('ProfileScreen shows Loading...', (tester) async {
    final mockGet = MockGetProfileUseCase();

    when(() => mockGet.call()).thenAnswer(
      (_) => Completer<Either<Failure, ProfileEntity>>().future, 
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          getProfileUseCaseProvider.overrideWithValue(mockGet),
        ],
        child: const MaterialApp(home: ProfileScreen()),
      ),
    );

    await tester.pump(); 

    expect(find.text('Loading...'), findsOneWidget);
  });
}
