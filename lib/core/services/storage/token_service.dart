import 'package:sajilo_sewa/core/services/storage/user_session_service.dart';

abstract class ITokenService {
  Future<String?> getToken();
  Future<void> clearToken();
}

class TokenService implements ITokenService {
  TokenService._();
  static final TokenService instance = TokenService._();

  @override
  Future<String?> getToken() async {
    return UserSessionService.instance.getToken();
  }

  @override
  Future<void> clearToken() async {
    await UserSessionService.instance.clearSession();
  }
}
