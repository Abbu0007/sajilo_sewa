import 'storage_service.dart';

class UserSessionService {
  UserSessionService._();
  static final UserSessionService instance = UserSessionService._();

  static const _kLoggedIn = 'session_logged_in';
  static const _kUserKey = 'session_user_key';
  static const _kRole = 'session_role';
  static const _kToken = 'session_token';

  static const _kServiceSlug = 'session_service_slug';

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

    
    String? serviceSlug,
  }) async {
    await StorageService.instance.setBool(_kLoggedIn, true);
    await StorageService.instance.setString(_kUserKey, userKey);
    await StorageService.instance.setString(_kRole, role);
    await StorageService.instance.setString(_kToken, token);

    
    if (serviceSlug != null && serviceSlug.trim().isNotEmpty) {
      await StorageService.instance.setString(_kServiceSlug, serviceSlug.trim());
    } else {
      await StorageService.instance.remove(_kServiceSlug);
    }
  }

  bool isLoggedIn() {
    final loggedIn = StorageService.instance.getBool(_kLoggedIn) ?? false;
    final token = getToken();
    return loggedIn && token != null && token.isNotEmpty;
  }

  String? getUserKey() => StorageService.instance.getString(_kUserKey);
  String? getRole() => StorageService.instance.getString(_kRole);
  String? getToken() => StorageService.instance.getString(_kToken);

  
  String? getServiceSlug() => StorageService.instance.getString(_kServiceSlug);

  String getRoleNormalized() {
    return (getRole() ?? '').trim().toLowerCase();
  }

  Future<void> clearSession() async {
    await StorageService.instance.setBool(_kLoggedIn, false);
    await StorageService.instance.remove(_kUserKey);
    await StorageService.instance.remove(_kRole);
    await StorageService.instance.remove(_kToken);

    await StorageService.instance.remove(_kServiceSlug);
  }
}
