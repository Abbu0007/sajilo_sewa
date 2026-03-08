import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sajilo_sewa/features/provider_dashboard/domain/entities/provider_me_entity.dart';
import 'package:sajilo_sewa/features/provider_dashboard/domain/entities/provider_profile_entity.dart';
import 'package:sajilo_sewa/features/provider_dashboard/domain/usecases/get_provider_me_usecase.dart';
import 'package:sajilo_sewa/features/provider_dashboard/domain/usecases/get_provider_profile_usecase.dart';
import 'package:sajilo_sewa/features/provider_dashboard/domain/usecases/get_provider_total_earnings_usecase.dart';
import 'package:sajilo_sewa/features/provider_dashboard/domain/usecases/update_provider_me_usecase.dart';
import 'package:sajilo_sewa/features/provider_dashboard/domain/usecases/update_provider_profile_usecase.dart';
import 'package:sajilo_sewa/features/provider_dashboard/domain/usecases/upload__provider_avatar_usecase.dart';
import 'package:sajilo_sewa/features/provider_dashboard/presentation/view_model/provider_profile_notifier.dart';

class MockGetProviderMeUseCase extends Mock implements GetProviderMeUseCase {}

class MockGetProviderProfileUseCase extends Mock
    implements GetProviderProfileUseCase {}

class MockGetProviderTotalEarningsUseCase extends Mock
    implements GetProviderTotalEarningsUseCase {}

class MockUpdateProviderProfileUseCase extends Mock
    implements UpdateProviderProfileUseCase {}

class MockUpdateProviderMeUseCase extends Mock
    implements UpdateProviderMeUseCase {}

class MockUploadProviderAvatarUseCase extends Mock
    implements UploadProviderAvatarUseCase {}

void main() {
  late MockGetProviderMeUseCase mockGetProviderMeUseCase;
  late MockGetProviderProfileUseCase mockGetProviderProfileUseCase;
  late MockGetProviderTotalEarningsUseCase mockGetProviderTotalEarningsUseCase;
  late MockUpdateProviderProfileUseCase mockUpdateProviderProfileUseCase;
  late MockUpdateProviderMeUseCase mockUpdateProviderMeUseCase;
  late MockUploadProviderAvatarUseCase mockUploadProviderAvatarUseCase;
  late ProviderProfileNotifier notifier;

  const me = ProviderMeEntity(
    id: 'u1',
    firstName: 'Abhi',
    lastName: 'Dhamala',
    profession: 'Plumber',
  );

  const profile = ProviderProfileEntity(
    id: 'p1',
    userId: 'u1',
    profession: 'Plumber',
    bio: 'Bio',
    startingPrice: 500,
    serviceAreas: ['Kathmandu'],
    availability: 'Available',
    ratingAvg: 4.5,
    ratingCount: 12,
    completedJobs: 40,
  );

  setUp(() {
    mockGetProviderMeUseCase = MockGetProviderMeUseCase();
    mockGetProviderProfileUseCase = MockGetProviderProfileUseCase();
    mockGetProviderTotalEarningsUseCase = MockGetProviderTotalEarningsUseCase();
    mockUpdateProviderProfileUseCase = MockUpdateProviderProfileUseCase();
    mockUpdateProviderMeUseCase = MockUpdateProviderMeUseCase();
    mockUploadProviderAvatarUseCase = MockUploadProviderAvatarUseCase();

    notifier = ProviderProfileNotifier(
      getMe: mockGetProviderMeUseCase,
      getProfile: mockGetProviderProfileUseCase,
      getTotalEarnings: mockGetProviderTotalEarningsUseCase,
      updateProfile: mockUpdateProviderProfileUseCase,
      updateMe: mockUpdateProviderMeUseCase,
      uploadAvatar: mockUploadProviderAvatarUseCase,
    );
  });

  testWidgets('provider profile notifier initial state is correct',
      (tester) async {
    await tester.pump();

    expect(notifier.state.loading, false);
    expect(notifier.state.error, null);
    expect(notifier.state.me, null);
    expect(notifier.state.profile, null);
    expect(notifier.state.totalEarnings, 0);
  });

  testWidgets('provider profile notifier load updates state successfully',
      (tester) async {
    when(() => mockGetProviderMeUseCase.call()).thenAnswer((_) async => me);
    when(() => mockGetProviderProfileUseCase.call())
        .thenAnswer((_) async => profile);
    when(() => mockGetProviderTotalEarningsUseCase.call())
        .thenAnswer((_) async => 2500);

    await notifier.load();
    await tester.pump();

    expect(notifier.state.loading, false);
    expect(notifier.state.error, null);
    expect(notifier.state.me?.id, 'u1');
    expect(notifier.state.profile?.id, 'p1');
    expect(notifier.state.totalEarnings, 2500);
  });

  testWidgets('provider profile notifier refreshEarnings updates amount',
      (tester) async {
    when(() => mockGetProviderTotalEarningsUseCase.call())
        .thenAnswer((_) async => 3000);

    await notifier.refreshEarnings();
    await tester.pump();

    expect(notifier.state.totalEarnings, 3000);
    expect(notifier.state.error, null);
  });

  testWidgets('provider profile notifier saveEditProfile success returns true',
      (tester) async {
    when(() => mockUpdateProviderMeUseCase.call(
          firstName: 'Abhi',
          lastName: 'Dhamala',
        )).thenAnswer((_) async => me);
    when(() => mockUpdateProviderProfileUseCase.call(
          profession: 'Plumber',
          startingPrice: 1200,
        )).thenAnswer((_) async => profile);
    when(() => mockGetProviderTotalEarningsUseCase.call())
        .thenAnswer((_) async => 5000);

    final result = await notifier.saveEditProfile(
      firstName: 'Abhi',
      lastName: 'Dhamala',
      startingPrice: 1200,
    );
    await tester.pump();

    expect(result, true);
    expect(notifier.state.loading, false);
    expect(notifier.state.me?.profession, 'Plumber');
    expect(notifier.state.profile?.profession, 'Plumber');
    expect(notifier.state.totalEarnings, 5000);
  });

  testWidgets('provider profile notifier uploadMyAvatar success returns true',
      (tester) async {
    when(() => mockUploadProviderAvatarUseCase.call('avatar.png'))
        .thenAnswer((_) async => me);

    final result = await notifier.uploadMyAvatar('avatar.png');
    await tester.pump();

    expect(result, true);
    expect(notifier.state.loading, false);
    expect(notifier.state.me?.id, 'u1');
    expect(notifier.state.error, null);
  });
}