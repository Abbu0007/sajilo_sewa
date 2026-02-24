import 'package:flutter/foundation.dart';
import '../../domain/entities/provider_me_entity.dart';
import '../../domain/entities/provider_booking_entity.dart';
import '../../domain/usecases/get_provider_bookings_usecase.dart';
import '../../domain/usecases/get_provider_me_usecase.dart';

class ProviderHomeController extends ChangeNotifier {
  final GetProviderMeUseCase getMe;
  final GetProviderBookingsUseCase getBookings;

  ProviderHomeController({
    required this.getMe,
    required this.getBookings,
  });

  bool loading = false;
  String? error;

  ProviderMeEntity? me;
  List<ProviderBookingEntity> bookings = [];

  int countPending = 0;
  int countConfirmed = 0;
  int countInProgress = 0;
  int countCompleted = 0;

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      me = await getMe();
      bookings = await getBookings(status: "all");

      countPending = bookings.where((b) => b.status == "pending").length;
      countConfirmed = bookings.where((b) => b.status == "confirmed").length;
      countInProgress = bookings.where((b) => b.status == "in_progress").length;
      countCompleted = bookings.where((b) => b.status == "completed").length;
    } catch (e) {
      error = e.toString().replaceFirst('Exception: ', '');
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}