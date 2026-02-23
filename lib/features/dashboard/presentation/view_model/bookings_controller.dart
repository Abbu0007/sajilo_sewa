import 'package:flutter/foundation.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/usecases/get_my_bookings_usecase.dart';

class BookingsController extends ChangeNotifier {
  final GetMyBookingsUseCase getMyBookings;

  BookingsController({required this.getMyBookings});

  bool loading = false;
  String? error;

  String status = "all"; // all | pending | accepted | completed | cancelled etc.
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
}