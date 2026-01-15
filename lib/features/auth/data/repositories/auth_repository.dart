import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sajilo_sewa/core/error/failures.dart';
import 'package:sajilo_sewa/features/auth/data/datasources/auth_datasource.dart';
import 'package:sajilo_sewa/features/auth/domain/repositories/auth_repository.dart';
import 'package:sajilo_sewa/features/auth/presentation/providers/auth_providers.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final ds = ref.read(authDataSourceProvider);
  return AuthRepository(authDatasource: ds);
});

class AuthRepository implements IAuthRepository {
  final IAuthDataSource _authDataSource;

  AuthRepository({required IAuthDataSource authDatasource})
    : _authDataSource = authDatasource;

  @override
  Future<Either<Failure, Unit>> signUp({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String role,
    String? profession,
  }) async {
    try {
      await _authDataSource.signUp(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
        role: role,
        profession: profession,
      );
      return right(unit);
    } catch (e) {
      if (e is Failure) return left(e);
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> login({
    required String email,
    required String password,
  }) async {
    try {
      final role = await _authDataSource.login(
        email: email,
        password: password,
      );
      return right(role);
    } catch (e) {
      if (e is Failure) return left(e);
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await _authDataSource.logout();
      return right(unit);
    } catch (e) {
      if (e is Failure) return left(e);
      return left(ServerFailure(message: e.toString()));
    }
  }
}
