import 'package:flutter/foundation.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/usecases/get_my_bookings_usecase.dart';
import '../../domain/usecases/cancel_booking_usecase.dart';
import '../../domain/usecases/confirm_payment_usecase.dart';

class BookingsController extends ChangeNotifier {
  final GetMyBookingsUseCase getMyBookings;
  final CancelBookingUseCase cancelBooking;
  final ConfirmPaymentUseCase confirmPayment;

  BookingsController({
    required this.getMyBookings,
    required this.cancelBooking,
    required this.confirmPayment,
  });

  bool loading = false;
  String? error;

  String status = "all";

  List<BookingEntity> items = [];

  Future<void> load({String? newStatus}) async {
    if (newStatus != null) status = newStatus;

    loading = true;
    error = null;
    notifyListeners();

    try {
      items = await getMyBookings(status: status);
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> doCancel(String bookingId, {String? reason}) async {
    try {
      await cancelBooking(bookingId, reason: reason);
      await load();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    }
  }

  Future<void> doConfirmPayment(String bookingId) async {
    try {
      await confirmPayment(bookingId);

      await load();
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
    }
  }

  bool canCancel(BookingEntity b) {
    return b.status == "pending" || b.status == "confirmed";
  }

  bool canConfirmPayment(BookingEntity b) {
    return b.status == "awaiting_payment_confirmation";
  }

  bool isCompleted(BookingEntity b) {
    return b.status == "completed";
  }

  bool isCancelled(BookingEntity b) {
    return b.status == "cancelled";
  }
}