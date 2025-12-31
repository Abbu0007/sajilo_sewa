import 'package:either_dart/either.dart';
import 'package:hive/hive.dart';
import '../../../../core/constants/hive_table_constants.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> signUp(UserEntity user);
  Future<Either<Failure, UserEntity>> login(String email, String password);
}

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Either<Failure, void>> signUp(UserEntity user) async {
    try {
      final box = await Hive.openBox(HiveTableConstants.authBox);

      final model = UserModel.fromEntity(user);

      await box.put(HiveTableConstants.authUserKey, model.toMap());
      return const Right(null);
    } catch (_) {
      return const Left(HiveFailure("Signup failed"));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
  ) async {
    try {
      final box = await Hive.openBox(HiveTableConstants.authBox);

      final data = box.get(HiveTableConstants.authUserKey);

      if (data == null) {
        return const Left(HiveFailure("User does not exist. Please sign up."));
      }

      final user = UserModel.fromMap(Map<String, dynamic>.from(data));

      if (user.email != email) {
        return const Left(HiveFailure("Email not found"));
      }

      if (user.password != password) {
        return const Left(HiveFailure("Incorrect password"));
      }

      return Right(user.toEntity());
    } catch (_) {
      return const Left(HiveFailure("Something went wrong during login"));
    }
  }
}
