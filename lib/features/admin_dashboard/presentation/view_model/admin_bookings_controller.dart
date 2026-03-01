import 'package:flutter_riverpod/legacy.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/entities/admin_booking_entity.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/repositories/i_admin_bookings_repository.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/usecases/cancel_admin_booking_usecase.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/usecases/delete_admin_booking_usecase.dart';
import 'package:sajilo_sewa/features/admin_dashboard/domain/usecases/get_admin_bookings_usecase.dart';
import 'package:sajilo_sewa/features/admin_dashboard/presentation/providers/admin_providers.dart';

class AdminBookingsState {
  final List<AdminBookingEntity> items;
  final int page;
  final int limit;
  final int totalPages;
  final int total;
  final String status;
  final String q;
  final bool loading;
  final bool loadingMore;
  final String? error;

  const AdminBookingsState({
    required this.items,
    required this.page,
    required this.limit,
    required this.totalPages,
    required this.total,
    required this.status,
    required this.q,
    required this.loading,
    required this.loadingMore,
    required this.error,
  });

  factory AdminBookingsState.initial() => const AdminBookingsState(
        items: <AdminBookingEntity>[],
        page: 1,
        limit: 20,
        totalPages: 1,
        total: 0,
        status: 'all',
        q: '',
        loading: true,
        loadingMore: false,
        error: null,
      );

  AdminBookingsState copyWith({
    List<AdminBookingEntity>? items,
    int? page,
    int? limit,
    int? totalPages,
    int? total,
    String? status,
    String? q,
    bool? loading,
    bool? loadingMore,
    String? error, 
  }) {
    return AdminBookingsState(
      items: items ?? this.items,
      page: page ?? this.page,
      limit: limit ?? this.limit,
      totalPages: totalPages ?? this.totalPages,
      total: total ?? this.total,
      status: status ?? this.status,
      q: q ?? this.q,
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      error: error,
    );
  }
}

final adminBookingsControllerProvider =
    StateNotifierProvider<AdminBookingsController, AdminBookingsState>((ref) {
  return AdminBookingsController(
    getBookings: ref.read(getAdminBookingsUseCaseProvider),
    cancelBooking: ref.read(cancelAdminBookingUseCaseProvider),
    deleteBooking: ref.read(deleteAdminBookingUseCaseProvider),
  )..loadFirst();
});

class AdminBookingsController extends StateNotifier<AdminBookingsState> {
  final GetAdminBookingsUseCase getBookings;
  final CancelAdminBookingUseCase cancelBooking;
  final DeleteAdminBookingUseCase deleteBooking;

  AdminBookingsController({
    required this.getBookings,
    required this.cancelBooking,
    required this.deleteBooking,
  }) : super(AdminBookingsState.initial());

  Future<void> loadFirst() async {
    state = state.copyWith(
      loading: true,
      loadingMore: false,
      error: null,
      page: 1,
      items: <AdminBookingEntity>[],
    );

    final res = await getBookings(
      page: 1,
      limit: state.limit,
      status: state.status,
      q: state.q,
    );

    res.fold(
      (f) => state = state.copyWith(loading: false, error: f.message ?? 'Failed to load bookings'),
      (AdminBookingPageEntity page) => state = state.copyWith(
        loading: false,
        error: null,
        items: page.items,
        page: page.page,
        limit: page.limit,
        total: page.total,
        totalPages: page.totalPages,
      ),
    );
  }

  Future<void> loadMore() async {
    if (state.loadingMore) return;
    if (state.page >= state.totalPages) return;

    state = state.copyWith(loadingMore: true, error: null);
    final nextPage = state.page + 1;

    final res = await getBookings(
      page: nextPage,
      limit: state.limit,
      status: state.status,
      q: state.q,
    );

    res.fold(
      (f) => state = state.copyWith(loadingMore: false, error: f.message ?? 'Failed to load more'),
      (AdminBookingPageEntity page) => state = state.copyWith(
        loadingMore: false,
        error: null,
        items: <AdminBookingEntity>[...state.items, ...page.items],
        page: page.page,
        limit: page.limit,
        total: page.total,
        totalPages: page.totalPages,
      ),
    );
  }

  void setStatus(String status) {
    state = state.copyWith(status: status, page: 1);
    loadFirst();
  }

  void setQuery(String q) {
    state = state.copyWith(q: q, page: 1);
    loadFirst();
  }

  Future<String?> adminCancel(String bookingId, String reason) async {
    final old = state.items;
    final idx = old.indexWhere((b) => b.id == bookingId);
    if (idx == -1) return null;

    // optimistic update
    final optimistic = old[idx];
    final optimisticUpdated = AdminBookingEntity(
      id: optimistic.id,
      status: 'cancelled',
      scheduledAt: optimistic.scheduledAt,
      note: optimistic.note,
      addressText: optimistic.addressText,
      price: optimistic.price,
      paymentStatus: optimistic.paymentStatus,
      service: optimistic.service,
      client: optimistic.client,
      provider: optimistic.provider,
    );

    final next = <AdminBookingEntity>[
      ...old.sublist(0, idx),
      optimisticUpdated,
      ...old.sublist(idx + 1),
    ];

    state = state.copyWith(items: next, error: null);

    final res = await cancelBooking(id: bookingId, reason: reason);

    return res.fold(
      (f) {
        state = state.copyWith(items: old, error: f.message);
        return f.message ?? 'Cancel failed';
      },
      (updated) {
        final now = state.items.map((x) => x.id == bookingId ? updated : x).toList();
        state = state.copyWith(items: now, error: null);
        return null;
      },
    );
  }

  Future<String?> adminDelete(String bookingId) async {
    final old = state.items;
    state = state.copyWith(items: old.where((b) => b.id != bookingId).toList(), error: null);

    final res = await deleteBooking(bookingId);

    return res.fold(
      (f) {
        state = state.copyWith(items: old, error: f.message);
        return f.message ?? 'Delete failed';
      },
      (_) => null,
    );
  }
}