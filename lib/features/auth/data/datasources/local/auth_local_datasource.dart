import 'package:sajilo_sewa/core/services/hive/hive_service.dart';

class AuthLocalDatasource {
  final HiveService _hive;
  AuthLocalDatasource(this._hive);

  Future<void> signUp({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String role,
    String? profession,
  }) async {
    final res = await _hive.signUp(
      fullName: fullName,
      email: email,
      phone: phone,
      password: password,
      role: role,
      profession: profession,
    );

    res.fold((f) => throw f, (_) => null);
  }

  Future<String> login({
    required String email,
    required String password,
  }) async {
    final res = await _hive.login(email: email, password: password);
    return res.fold((f) => throw f, (role) => role);
  }

  Future<void> logout() async {
    final res = await _hive.logout();
    res.fold((f) => throw f, (_) => null);
  }
}
