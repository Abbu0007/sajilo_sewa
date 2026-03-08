import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sajilo_sewa/core/error/failures.dart';
import 'package:sajilo_sewa/features/dashboard/domain/entities/profile_entity.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/get_profile_usecase.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/update_profile_usecase.dart';
import 'package:sajilo_sewa/features/dashboard/domain/usecases/upload_avatar_usecase.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/providers/profile_providers.dart';
import 'package:sajilo_sewa/features/dashboard/presentation/view_model/profile_view_model.dart';

class MockGetProfileUseCase extends Mock implements GetProfileUseCase {}

class MockUpdateProfileUseCase extends Mock implements UpdateProfileUseCase {}

class MockUploadAvatarUseCase extends Mock implements UploadAvatarUseCase {}

class FakeFailure extends Failure {
  FakeFailure(String message) : super(message: message);
}

void main() {
  late MockGetProfileUseCase mockGetProfileUseCase;
  late MockUpdateProfileUseCase mockUpdateProfileUseCase;
  late MockUploadAvatarUseCase mockUploadAvatarUseCase;
  late ProviderContainer container;

  const profile = ProfileEntity(
    id: 'u1',
    firstName: 'Abhishek',
    lastName: 'Dhamala',
    email: 'a@test.com',
    phone: '9800',
    role: 'client',
    avatarUrl: 'avatar.png',
  );

  setUpAll(() {
    registerFallbackValue(File('dummy_avatar.png'));
  });

  setUp(() {
    mockGetProfileUseCase = MockGetProfileUseCase();
    mockUpdateProfileUseCase = MockUpdateProfileUseCase();
    mockUploadAvatarUseCase = MockUploadAvatarUseCase();

    container = ProviderContainer(
      overrides: [
        getProfileUseCaseProvider.overrideWithValue(mockGetProfileUseCase),
        updateProfileUseCaseProvider.overrideWithValue(
          mockUpdateProfileUseCase,
        ),
        uploadAvatarUseCaseProvider.overrideWithValue(
          mockUploadAvatarUseCase,
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  testWidgets('profile view model initial state is correct', (tester) async {
    final state = container.read(profileViewModelProvider);

    await tester.pump();

    expect(state.isLoading, false);
    expect(state.isSaving, false);
    expect(state.error, null);
    expect(state.profile, null);
  });

  testWidgets('profile view model loadProfile success updates state',
      (tester) async {
    when(() => mockGetProfileUseCase.call())
        .thenAnswer((_) async => const Right(profile));

    final notifier = container.read(profileViewModelProvider.notifier);

    await notifier.loadProfile();
    await tester.pump();

    final state = container.read(profileViewModelProvider);

    expect(state.isLoading, false);
    expect(state.error, null);
    expect(state.profile?.fullName, 'Abhishek Dhamala');
  });

  testWidgets('profile view model loadProfile failure updates error',
      (tester) async {
    when(() => mockGetProfileUseCase.call())
        .thenAnswer((_) async => Left(FakeFailure('Load failed')));

    final notifier = container.read(profileViewModelProvider.notifier);

    await notifier.loadProfile();
    await tester.pump();

    final state = container.read(profileViewModelProvider);

    expect(state.isLoading, false);
    expect(state.error, 'Load failed');
  });

  testWidgets('profile view model updateProfile success returns true',
      (tester) async {
    when(() => mockUpdateProfileUseCase.call(
          firstName: 'Abhi',
          lastName: 'Dhamala',
          phone: '9800',
          email: 'a@test.com',
        )).thenAnswer((_) async => const Right(profile));

    final notifier = container.read(profileViewModelProvider.notifier);

    final result = await notifier.updateProfile(
      firstName: 'Abhi',
      lastName: 'Dhamala',
      phone: '9800',
      email: 'a@test.com',
    );
    await tester.pump();

    final state = container.read(profileViewModelProvider);

    expect(result, true);
    expect(state.isSaving, false);
    expect(state.profile?.id, 'u1');
  });

  testWidgets('profile view model uploadAvatar success returns true',
      (tester) async {
    when(() => mockUploadAvatarUseCase.call(file: any(named: 'file')))
        .thenAnswer((_) async => const Right(profile));

    final notifier = container.read(profileViewModelProvider.notifier);

    final result = await notifier.uploadAvatar(File('avatar.png'));
    await tester.pump();

    final state = container.read(profileViewModelProvider);

    expect(result, true);
    expect(state.isSaving, false);
    expect(state.profile?.avatarUrl, 'avatar.png');
  });

  testWidgets('profile view model clearError removes error', (tester) async {
    when(() => mockGetProfileUseCase.call())
        .thenAnswer((_) async => Left(FakeFailure('Error text')));

    final notifier = container.read(profileViewModelProvider.notifier);

    await notifier.loadProfile();
    notifier.clearError();
    await tester.pump();

    final state = container.read(profileViewModelProvider);

    expect(state.error, null);
  });
}