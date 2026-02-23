import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sajilo_sewa/features/admin_dashboard/data/datasources/remote/admin_remote_datasource.dart';
import 'package:sajilo_sewa/features/admin_dashboard/data/repositories/admin_repository_impl.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/repositories/i_admin_repository.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/usecases/create_user_usecase.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/usecases/delete_user_usecase.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/usecases/get_users_by_role_usecase.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/usecases/update_user_usecase.dart';
import 'package:sajilo_sewa/features/auth/presentation/providers/auth_providers.dart';

final adminRemoteDatasourceProvider = Provider<AdminRemoteDatasource>(
  (ref) => AdminRemoteDatasource(ref.read(apiClientProvider).dio),
);

final adminRepositoryProvider = Provider<IAdminRepository>(
  (ref) => AdminRepositoryImpl(
    remote: ref.read(adminRemoteDatasourceProvider),
  ),
);

final createUserUseCaseProvider = Provider<CreateUserUseCase>(
  (ref) => CreateUserUseCase(ref.read(adminRepositoryProvider)),
);


final getUsersByRoleUseCaseProvider = Provider<GetUsersByRoleUseCase>(
  (ref) => GetUsersByRoleUseCase(ref.read(adminRepositoryProvider)),
);

final updateUserUseCaseProvider = Provider<UpdateUserUseCase>(
  (ref) => UpdateUserUseCase(ref.read(adminRepositoryProvider)),
);

final deleteUserUseCaseProvider = Provider<DeleteUserUseCase>(
  (ref) => DeleteUserUseCase(ref.read(adminRepositoryProvider)),
);
