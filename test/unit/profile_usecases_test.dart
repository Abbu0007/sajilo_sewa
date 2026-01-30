import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sajilo_sewa/core/error/failures.dart';
import 'package:sajilo_sewa/features/profile/domain/entities/profile_entity.dart';
import 'package:sajilo_sewa/features/profile/domain/repositories/profile_repository.dart';
import 'package:sajilo_sewa/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:sajilo_sewa/features/profile/domain/usecases/upload_avatar_usecase.dart';

class MockProfileRepository extends Mock implements IProfileRepository {}

void main() {
  late MockProfileRepository repo;

  setUp(() {
    repo = MockProfileRepository();
  });

  final profile = ProfileEntity(
    id: "1",
    firstName: "A",
    lastName: "B",
    email: "a@test.com",
    phone: "9800",
    role: "client",
    profession: null,
    avatarUrl: "",
  );

  group('Profile Usecases', () {
    test('GetProfileUseCase calls repo.getMe()', () async {
      when(() => repo.getMe()).thenAnswer((_) async => right(profile));

      final usecase = GetProfileUseCase(repo);
      final result = await usecase();

      verify(() => repo.getMe()).called(1);
      expect(result.isRight(), true);
    });

    test('UploadAvatarUseCase calls repo.uploadAvatar()', () async {
      registerFallbackValue(File('x.png'));

      when(() => repo.uploadAvatar(file: any(named: 'file')))
          .thenAnswer((_) async => right(profile));

      final usecase = UploadAvatarUseCase(repo);
      final result = await usecase(file: File('x.png'));

      verify(() => repo.uploadAvatar(file: any(named: 'file'))).called(1);
      expect(result.isRight(), true);
    });

    test('Usecase returns Failure when repository returns Failure', () async {
      when(() => repo.getMe()).thenAnswer((_) async => left(ServerFailure(message: "err")));

      final usecase = GetProfileUseCase(repo);
      final result = await usecase();

      expect(result.isLeft(), true);
    });
  });
}
