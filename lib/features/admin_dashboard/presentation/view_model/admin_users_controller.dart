import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/entities/admin_user_entity.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/usecases/delete_user_usecase.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/usecases/get_users_by_role_usecase.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/usecases/update_user_usecase.dart';
import 'package:sajilo_sewa/features/admin_dashboard/presentation/providers/admin_providers.dart';

final adminUsersControllerProvider = StateNotifierProvider.family<
    AdminUsersController,
    AsyncValue<List<AdminUserEntity>>,
    String>((ref, role) {
  return AdminUsersController(
    role: role,
    getUsersByRole: ref.read(getUsersByRoleUseCaseProvider),
    updateUserUseCase: ref.read(updateUserUseCaseProvider),
    deleteUserUseCase: ref.read(deleteUserUseCaseProvider),
  )..load();
});

class AdminUsersController
    extends StateNotifier<AsyncValue<List<AdminUserEntity>>> {
  final String role;
  final GetUsersByRoleUseCase getUsersByRole;
  final UpdateUserUseCase updateUserUseCase;
  final DeleteUserUseCase deleteUserUseCase;

  AdminUsersController({
    required this.role,
    required this.getUsersByRole,
    required this.updateUserUseCase,
    required this.deleteUserUseCase,
  }) : super(const AsyncValue.loading());

  Future<void> load() async {
    state = const AsyncValue.loading();

    final res = await getUsersByRole(role: role);
    state = res.fold(
      (failure) => AsyncValue.error(
        failure.message ?? 'Failed to load users',
        StackTrace.current,
        ),
      (users) => AsyncValue.data(users)
    );
  }

  Future<void> refresh() => load();

  Future<String?> editUser({
    required String userId,
    required String fullName,
    required String phone,
    required String role,
    String? profession,
    XFile? avatarFile,
  }) async {
    final previous = state.value ?? const <AdminUserEntity>[];

    final res = await updateUserUseCase(
      userId: userId,
      fullName: fullName,
      phone: phone,
      role: role,
      profession: profession,
      avatarFile: avatarFile,
    );

    return res.fold(
      (failure) => failure.message ?? 'Update failed',
      (updated) {
        final next =
            previous.map((u) => u.id == userId ? updated : u).toList();
        state = AsyncValue.data(next);
        return null;
      },
    );
  }

  Future<String?> removeUser(String userId) async {
    final previous = state.value ?? const <AdminUserEntity>[];

    state =
        AsyncValue.data(previous.where((u) => u.id != userId).toList());

    final res = await deleteUserUseCase(userId: userId);

    return res.fold(
      (failure) {
        state = AsyncValue.data(previous);
        return failure.message ?? 'Delete failed';
      },
      (_) => null,
    );
  }
}
