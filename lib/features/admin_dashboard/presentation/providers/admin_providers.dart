import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sajilo_sewa/features/admin_dashboard/data/datasources/remote/admin_bookings_remote_datasource.dart';
import 'package:sajilo_sewa/features/admin_dashboard/data/datasources/remote/admin_remote_datasource.dart';
import 'package:sajilo_sewa/features/admin_dashboard/data/repositories/admin_bookings_repository_impl.dart';
import 'package:sajilo_sewa/features/admin_dashboard/data/repositories/admin_repository_impl.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/entities/admin_service_entity.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/repositories/i_admin_bookings_repository.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/repositories/i_admin_repository.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/usecases/cancel_admin_booking_usecase.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/usecases/create_user_usecase.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/usecases/delete_admin_booking_usecase.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/usecases/delete_user_usecase.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/usecases/get_admin_booking_usecase.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/usecases/get_admin_bookings_usecase.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/usecases/get_admin_services_usecase.dart';
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

final getAdminServicesUseCaseProvider = Provider<GetAdminServicesUseCase>(
  (ref) => GetAdminServicesUseCase(ref.read(adminRepositoryProvider)),
);

final adminServicesProvider = FutureProvider<List<AdminServiceEntity>>((ref) async {
  final usecase = ref.read(getAdminServicesUseCaseProvider);
  final res = await usecase();
  return res.fold((f) => throw Exception(f.message ?? 'Failed to load services'), (items) => items);
});

final adminBookingsRemoteDatasourceProvider = Provider<AdminBookingsRemoteDatasource>(
  (ref) => AdminBookingsRemoteDatasource(ref.read(apiClientProvider).dio),
);

final adminBookingsRepositoryProvider = Provider<IAdminBookingsRepository>(
  (ref) => AdminBookingsRepositoryImpl(remote: ref.read(adminBookingsRemoteDatasourceProvider)),
);

final getAdminBookingsUseCaseProvider = Provider<GetAdminBookingsUseCase>(
  (ref) => GetAdminBookingsUseCase(ref.read(adminBookingsRepositoryProvider)),
);

final getAdminBookingUseCaseProvider = Provider<GetAdminBookingUseCase>(
  (ref) => GetAdminBookingUseCase(ref.read(adminBookingsRepositoryProvider)),
);

final cancelAdminBookingUseCaseProvider = Provider<CancelAdminBookingUseCase>(
  (ref) => CancelAdminBookingUseCase(ref.read(adminBookingsRepositoryProvider)),
);

final deleteAdminBookingUseCaseProvider = Provider<DeleteAdminBookingUseCase>(
  (ref) => DeleteAdminBookingUseCase(ref.read(adminBookingsRepositoryProvider)),
);