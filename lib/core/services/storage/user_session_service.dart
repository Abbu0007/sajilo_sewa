import 'storage_service.dart';

class UserSessionService {
  UserSessionService._();
  static final UserSessionService instance = UserSessionService._();

  static const _kLoggedIn = 'session_logged_in';
  static const _kUserKey = 'session_user_key';
  static const _kRole = 'session_role';
  static const _kToken = 'session_token';
  static const _kOnboardingDone = 'onboarding_done';

  Future<void> init() async {
    await StorageService.instance.init();
  }

  // Onboarding
  Future<void> setOnboardingDone(bool done) async {
    await StorageService.instance.setBool(_kOnboardingDone, done);
  }

  bool isOnboardingDone() {
    return StorageService.instance.getBool(_kOnboardingDone) ?? false;
  }

  // Session
  Future<void> saveSession({
    required String userKey,
    required String role,
    required String token,
  }) async {
    await StorageService.instance.setBool(_kLoggedIn, true);
    await StorageService.instance.setString(_kUserKey, userKey);
    await StorageService.instance.setString(_kRole, role);
    await StorageService.instance.setString(_kToken, token);
  }

  bool isLoggedIn() {
    return StorageService.instance.getBool(_kLoggedIn) ?? false;
  }

  String? getUserKey() => StorageService.instance.getString(_kUserKey);
  String? getRole() => StorageService.instance.getString(_kRole);
  String? getToken() => StorageService.instance.getString(_kToken);

  Future<void> clearSession() async {
    await StorageService.instance.setBool(_kLoggedIn, false);
    await StorageService.instance.remove(_kUserKey);
    await StorageService.instance.remove(_kRole);
    await StorageService.instance.remove(_kToken);
  }
}
