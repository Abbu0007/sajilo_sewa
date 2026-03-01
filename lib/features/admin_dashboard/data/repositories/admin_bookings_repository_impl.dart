import 'package:dartz/dartz.dart';
import 'package:sajilo_sewa/core/error/failures.dart';
import 'package:sajilo_sewa/features/admin_dashboard/data/datasources/remote/admin_bookings_remote_datasource.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/entities/admin_booking_entity.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/repositories/i_admin_bookings_repository.dart';

class AdminBookingsRepositoryImpl implements IAdminBookingsRepository {
  final AdminBookingsRemoteDatasource remote;
  AdminBookingsRepositoryImpl({required this.remote});

  @override
  Future<Either<Failure, AdminBookingPageEntity>> list({
    required int page,
    required int limit,
    String status = 'all',
    String q = '',
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    try {
      final res = await remote.list(
        page: page,
        limit: limit,
        status: status,
        q: q,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );

      return Right(
        AdminBookingPageEntity(
          items: res.items.map((e) => e.toEntity()).toList(),
          page: res.page,
          limit: res.limit,
          total: res.total,
          totalPages: res.totalPages,
        ),
      );
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminBookingEntity>> getById(String id) async {
    try {
      final b = await remote.getById(id);
      return Right(b.toEntity());
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AdminBookingEntity>> cancel({
    required String id,
    required String reason,
  }) async {
    try {
      final b = await remote.cancel(id: id, reason: reason);
      return Right(b.toEntity());
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> delete(String id) async {
    try {
      await remote.delete(id);
      return const Right(null);
    } catch (e) {
      if (e is Failure) return Left(e);
      return Left(ServerFailure(message: e.toString()));
    }
  }
}