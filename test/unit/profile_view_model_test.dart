import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sajilo_sewa/core/error/failures.dart';
import 'package:sajilo_sewa/features/profile/domain/entities/profile_entity.dart';
import 'package:sajilo_sewa/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:sajilo_sewa/features/profile/presentation/providers/profile_providers.dart';
import 'package:sajilo_sewa/features/profile/presentation/view_models/profile_view_model.dart';

class MockGetProfileUseCase extends Mock implements GetProfileUseCase {}

void main() {
  test('loadProfile success sets profile in state', () async {
    final uc = MockGetProfileUseCase();

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

    when(() => uc.call()).thenAnswer((_) async => right(profile));

    final container = ProviderContainer(
      overrides: [
        getProfileUseCaseProvider.overrideWithValue(uc),
      ],
    );
    addTearDown(container.dispose);

    await container.read(profileViewModelProvider.notifier).loadProfile();

    final state = container.read(profileViewModelProvider);
    expect(state.profile, isNotNull);
    expect(state.profile!.fullName, "Abhi Dhamala");
  });

  test('loadProfile failure sets error in state', () async {
    final uc = MockGetProfileUseCase();
    when(() => uc.call()).thenAnswer((_) async => left(ServerFailure(message: "bad")));

    final container = ProviderContainer(
      overrides: [
        getProfileUseCaseProvider.overrideWithValue(uc),
      ],
    );
    addTearDown(container.dispose);

    await container.read(profileViewModelProvider.notifier).loadProfile();

    final state = container.read(profileViewModelProvider);
    expect(state.error, "bad");
  });
}
