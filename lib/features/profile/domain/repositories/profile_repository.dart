import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:sajilo_sewa/core/error/failures.dart';
import 'package:sajilo_sewa/features/profile/domain/entities/profile_entity.dart';

abstract class IProfileRepository {
  Future<Either<Failure, ProfileEntity>> getMe();

  Future<Either<Failure, ProfileEntity>> updateMe({
    required String firstName,
    required String lastName,
    required String phone,
    String? email,
  });

  Future<Either<Failure, ProfileEntity>> uploadAvatar({
    required File file,
  });
}
