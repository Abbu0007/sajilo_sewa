import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:sajilo_sewa/core/error/failures.dart';
import 'package:sajilo_sewa/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:sajilo_sewa/features/profile/data/models/profile_api_model.dart';
import 'package:sajilo_sewa/features/profile/data/repositories/profile_repository.dart';

class MockProfileRemoteDatasource extends Mock implements IProfileRemoteDataSource {}

void main() {
  late MockProfileRemoteDatasource ds;
  late ProfileRepository repo;

  setUp(() {
    ds = MockProfileRemoteDatasource();
    repo = ProfileRepository(profileRemoteDataSource: ds);
  });

  final model = ProfileApiModel.fromJson({
    "id": "1",
    "firstName": "A",
    "lastName": "B",
    "email": "a@test.com",
    "phone": "9800",
    "role": "client",
    "avatarUrl": "",
  });

  group('ProfileRepository', () {
    test('getMe returns Right when datasource succeeds', () async {
      when(() => ds.getMe()).thenAnswer((_) async => model);

      final result = await repo.getMe();
      expect(result.isRight(), true);
    });

    test('getMe returns Left when datasource throws Failure', () async {
      when(() => ds.getMe()).thenThrow(ServerFailure(message: "boom"));

      final result = await repo.getMe();
      expect(result.isLeft(), true);
    });

    test('uploadAvatar returns Left when datasource throws Exception', () async {
      registerFallbackValue(File('x.png'));

      when(() => ds.uploadAvatar(file: any(named: 'file')))
          .thenThrow(Exception("x"));

      final result = await repo.uploadAvatar(file: File('x.png'));
      expect(result.isLeft(), true);
    });
  });
}
