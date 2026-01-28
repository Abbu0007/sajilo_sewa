import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:sajilo_sewa/core/error/failures.dart';
import 'package:sajilo_sewa/features/profile/domain/entities/profile_entity.dart';
import 'package:sajilo_sewa/features/profile/domain/repositories/profile_repository.dart';

class UploadAvatarUseCase {
  final IProfileRepository _repo;
  UploadAvatarUseCase(this._repo);

  Future<Either<Failure, ProfileEntity>> call({required File file}) {
    return _repo.uploadAvatar(file: file);
  }
}
