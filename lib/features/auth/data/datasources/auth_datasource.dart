import 'package:sajilo_sewa/core/error/failures.dart';
import 'package:sajilo_sewa/core/services/connectivity/network_info.dart';
import 'package:sajilo_sewa/core/services/hive/hive_service.dart';
import 'package:sajilo_sewa/core/services/storage/user_session_service.dart';
import 'package:sajilo_sewa/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:sajilo_sewa/features/auth/data/datasources/remote/auth_remote_datasource.dart';

abstract interface class IAuthDataSource {
  Future<void> signUp({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String role,
    String? profession,
  });

  Future<String> login({required String email, required String password});

  Future<void> logout();
}

/// Controls Remote + Local
class AuthDataSource implements IAuthDataSource {
  final NetworkInfo networkInfo;
  final AuthRemoteDatasource remote;
  final AuthLocalDatasource local;
  final HiveService hive;

  AuthDataSource({
    required this.networkInfo,
    required this.remote,
    required this.local,
    required this.hive,
  });

  @override
  Future<void> signUp({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String role,
    String? profession,
  }) async {
    try {
      final online = await networkInfo.isConnected;

      if (online) {
        final data = await remote.register(
          fullName: fullName,
          email: email,
          phone: phone,
          password: password,
          role: role,
          profession: profession,
        );

        await UserSessionService.instance.saveSession(
          userKey: data.user.email.trim().toLowerCase(),
          role: data.user.role,
          token: data.token,
        );

        await hive.cacheUserFromApi(
          id: data.user.id,
          fullName: data.user.toEntity().fullName,
          email: data.user.email,
          phone: data.user.phone,
          role: data.user.role,
          profession: data.user.profession,
          token: data.token,
        );

        return;
      }

      await local.signUp(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
        role: role,
        profession: profession,
      );
    } catch (e) {
      if (e is Failure) throw e;
      throw ServerFailure(message: 'Signup failed: $e');
    }
  }

  @override
  Future<String> login({
    required String email,
    required String password,
  }) async {
    try {
      final online = await networkInfo.isConnected;

      if (online) {
        final data = await remote.login(email: email, password: password);

        await UserSessionService.instance.saveSession(
          userKey: data.user.email.trim().toLowerCase(),
          role: data.user.role,
          token: data.token,
        );

        await hive.cacheUserFromApi(
          id: data.user.id,
          fullName: data.user.toEntity().fullName,
          email: data.user.email,
          phone: data.user.phone,
          role: data.user.role,
          profession: data.user.profession,
          token: data.token,
        );

        return data.user.role;
      }
      return await local.login(email: email, password: password);
    } catch (e) {
      if (e is Failure) throw e;
      throw ServerFailure(message: 'Login failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await UserSessionService.instance.clearSession();
      await local.logout();
    } catch (e) {
      if (e is Failure) throw e;
      throw ServerFailure(message: 'Logout failed: $e');
    }
  }
}
