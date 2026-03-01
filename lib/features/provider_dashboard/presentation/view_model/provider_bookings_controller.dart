import 'package:flutter/foundation.dart';
import 'package:sajilo_sewa/features/provider_dashboard/domain/usecases/create_rating_usecase.dart';
import '../../domain/entities/provider_booking_entity.dart';
import '../../domain/usecases/get_provider_bookings_usecase.dart';
import '../../domain/usecases/accept_booking_usecase.dart';
import '../../domain/usecases/reject_booking_usecase.dart';
import '../../domain/usecases/update_booking_status_usecase.dart';

class ProviderBookingsController extends ChangeNotifier {
  final GetProviderBookingsUseCase getBookings;
  final AcceptBookingUseCase accept;
  final RejectBookingUseCase reject;
  final UpdateBookingStatusUseCase updateStatus;
  final CreateRatingUseCase createRating;

  ProviderBookingsController({
    required this.getBookings,
    required this.accept,
    required this.reject,
    required this.updateStatus,
    required this.createRating,
  });

  bool loading = false;
  bool _actionBusy = false;
  bool get actionBusy => _actionBusy;

  String? error;
  List<ProviderBookingEntity> items = [];

  String _status = "all";
  String get status => _status;

  Future<void> load({String status = "all"}) async {
    _status = status;
    loading = true;
    error = null;
    notifyListeners();

    try {
      items = await getBookings(status: status);
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> acceptBooking(String bookingId, {String? reloadStatus}) async {
    await _runAction(() async {
      await accept(bookingId);
      await load(status: reloadStatus ?? _status);
    });
  }

  Future<void> rejectBooking(
    String bookingId, {
    String? reason,
    String? reloadStatus,
  }) async {
    await _runAction(() async {
      await reject(bookingId, reason: reason);
      await load(status: reloadStatus ?? _status);
    });
  }

  // ---------------------------------------------------
  // STATUS UPDATES (clean wrappers)
  // ---------------------------------------------------

  Future<void> markInProgress(
    String bookingId, {
    String? reloadStatus,
  }) async {
    await _runAction(() async {
      await updateStatus(
        bookingId,
        status: "in_progress",
      );
      await load(status: reloadStatus ?? _status);
    });
  }

  Future<void> requestPayment(
    String bookingId, {
    required num price,
    String? reason,
    String? reloadStatus,
  }) async {
    await _runAction(() async {
      await updateStatus(
        bookingId,
        status: "awaiting_payment_confirmation",
        reason: reason,
        price: price, // ⚠️ important
      );
      await load(status: reloadStatus ?? _status);
    });
  }

  Future<void> markCompleted(
    String bookingId, {
    String? reloadStatus,
  }) async {
    await _runAction(() async {
      await updateStatus(
        bookingId,
        status: "completed",
      );
      await load(status: reloadStatus ?? _status);
    });
  }

  Future<void> cancelBooking(
    String bookingId, {
    String? reason,
    String? reloadStatus,
  }) async {
    await _runAction(() async {
      await updateStatus(
        bookingId,
        status: "cancelled",
        reason: reason,
      );
      await load(status: reloadStatus ?? _status);
    });
  }

  Future<void> rate({
    required String bookingId,
    required int stars,
    String? comment,
  }) async {
    await _runAction(() async {
      await createRating(
        bookingId: bookingId,
        stars: stars,
        comment: comment,
      );
    });
  }

  Future<void> _runAction(Future<void> Function() action) async {
    _actionBusy = true;
    error = null;
    notifyListeners();

    try {
      await action();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _actionBusy = false;
      notifyListeners();
    }
  }
}