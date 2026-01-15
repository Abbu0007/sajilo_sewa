import 'package:dartz/dartz.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../constants/hive_table_constants.dart';
import '../../error/failures.dart';
import '../../services/storage/user_session_service.dart';
import '../../../features/auth/data/models/user_hive_model.dart';

class HiveService {
  HiveService._();
  static final HiveService instance = HiveService._();

  bool _initialized = false;

  static const String adminEmail = 'admin@sajilosewa.com';
  static const String adminPassword = 'admin123';

  Future<Either<Failure, Unit>> init() async {
    try {
      if (_initialized) return right(unit);

      await Hive.initFlutter();

      if (!Hive.isAdapterRegistered(UserHiveModelAdapter().typeId)) {
        Hive.registerAdapter(UserHiveModelAdapter());
      }

      await Hive.openBox<UserHiveModel>(HiveTableConstants.usersBox);
      await Hive.openBox<String>(HiveTableConstants.professionsBox);

      await _createAdminIfNotExists();

      _initialized = true;
      return right(unit);
    } catch (e) {
      return left(CacheFailure(message: 'Hive init failed: $e'));
    }
  }

  Future<void> _createAdminIfNotExists() async {
    final usersBox = Hive.box<UserHiveModel>(HiveTableConstants.usersBox);
    final key = adminEmail.trim().toLowerCase();

    if (usersBox.get(key) != null) return;

    final admin = UserHiveModel(
      id: 'admin',
      fullName: 'Admin',
      email: key,
      phone: '0000000000',
      password: adminPassword,
      role: 'admin',
      profession: null,
      createdAt: DateTime.now(),
    );

    await usersBox.put(key, admin);
  }

  Future<Either<Failure, Unit>> cacheUserFromApi({
    required String id,
    required String fullName,
    required String email,
    required String phone,
    required String role,
    String? profession,
    required String token,
  }) async {
    try {
      final usersBox = Hive.box<UserHiveModel>(HiveTableConstants.usersBox);
      final normalizedEmail = email.trim().toLowerCase();

      final user = UserHiveModel(
        id: id,
        fullName: fullName.trim(),
        email: normalizedEmail,
        phone: phone.trim(),
        password: '', // ✅ do not store API password
        role: role,
        profession: profession,
        createdAt: DateTime.now(),
      );

      await usersBox.put(normalizedEmail, user);

      await UserSessionService.instance.saveSession(
        userKey: normalizedEmail,
        role: role,
        token: token,
      );

      return right(unit);
    } catch (e) {
      return left(CacheFailure(message: 'Cache user failed: $e'));
    }
  }

  Future<Either<Failure, Unit>> signUp({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String role, // client | provider
    String? profession,
  }) async {
    try {
      final usersBox = Hive.box<UserHiveModel>(HiveTableConstants.usersBox);
      final normalizedEmail = email.trim().toLowerCase();

      if (normalizedEmail == adminEmail) {
        return left(
          ValidationFailure(message: 'This email is reserved for admin.'),
        );
      }

      if (usersBox.containsKey(normalizedEmail)) {
        return left(ValidationFailure(message: 'Email already registered.'));
      }

      if (role == 'provider') {
        final p = profession?.trim() ?? '';
        if (p.isEmpty) {
          return left(ValidationFailure(message: 'Profession is required.'));
        }
        await addProfession(p);
      }

      final user = UserHiveModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fullName: fullName.trim(),
        email: normalizedEmail,
        phone: phone.trim(),
        password: password,
        role: role,
        profession: role == 'provider' ? profession?.trim() : null,
        createdAt: DateTime.now(),
      );

      await usersBox.put(normalizedEmail, user);

      // offline session (no token)
      await UserSessionService.instance.saveSession(
        userKey: normalizedEmail,
        role: role,
        token: '',
      );

      return right(unit);
    } catch (e) {
      return left(CacheFailure(message: 'Signup failed: $e'));
    }
  }

  Future<Either<Failure, String>> login({
    required String email,
    required String password,
  }) async {
    try {
      final usersBox = Hive.box<UserHiveModel>(HiveTableConstants.usersBox);
      final normalizedEmail = email.trim().toLowerCase();

      final user = usersBox.get(normalizedEmail);
      if (user == null) {
        return left(AuthFailure(message: 'Account not found.'));
      }

      if (user.password != password) {
        return left(AuthFailure(message: 'Invalid credentials.'));
      }

      // offline session (no token)
      await UserSessionService.instance.saveSession(
        userKey: normalizedEmail,
        role: user.role,
        token: '',
      );

      return right(user.role);
    } catch (e) {
      return left(CacheFailure(message: 'Login failed: $e'));
    }
  }

  Future<Either<Failure, Unit>> logout() async {
    try {
      await UserSessionService.instance.clearSession();
      return right(unit);
    } catch (e) {
      return left(CacheFailure(message: 'Logout failed: $e'));
    }
  }

  Future<Either<Failure, UserHiveModel>> getSessionUser() async {
    try {
      final key = UserSessionService.instance.getUserKey();
      if (key == null || key.trim().isEmpty) {
        return left(CacheFailure(message: 'No active session.'));
      }

      final usersBox = Hive.box<UserHiveModel>(HiveTableConstants.usersBox);
      final user = usersBox.get(key.trim().toLowerCase());

      if (user == null) {
        return left(CacheFailure(message: 'Session user not found.'));
      }

      return right(user);
    } catch (e) {
      return left(CacheFailure(message: 'Load session user failed: $e'));
    }
  }

  Future<Either<Failure, List<String>>> getProfessions() async {
    try {
      final box = Hive.box<String>(HiveTableConstants.professionsBox);

      final list =
          box.values
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toSet()
              .toList()
            ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

      return right(list);
    } catch (e) {
      return left(CacheFailure(message: 'Load professions failed: $e'));
    }
  }

  Future<Either<Failure, Unit>> addProfession(String profession) async {
    try {
      final box = Hive.box<String>(HiveTableConstants.professionsBox);
      final value = profession.trim();

      if (value.isEmpty) return right(unit);

      final existing = box.values.map((e) => e.trim().toLowerCase()).toSet();
      if (existing.contains(value.toLowerCase())) return right(unit);

      await box.add(value);
      return right(unit);
    } catch (e) {
      return left(CacheFailure(message: 'Save profession failed: $e'));
    }
  }
}
