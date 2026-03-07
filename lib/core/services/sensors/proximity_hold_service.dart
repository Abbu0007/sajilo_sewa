import 'dart:async';
import 'package:proximity_sensor/proximity_sensor.dart';

class ProximityHoldService {
  ProximityHoldService._();
  static final ProximityHoldService instance = ProximityHoldService._();

  StreamSubscription<dynamic>? _subscription;
  Timer? _holdTimer;

  bool _started = false;
  bool _isNear = false;
  bool _holdStarted = false;

  void start({
    required void Function() onHoldCompleted,
    void Function()? onNearStarted,
    void Function()? onNearCancelled,
    Duration holdDuration = const Duration(seconds: 5),
  }) {
    if (_started) return;
    _started = true;

    _subscription = ProximitySensor.events.listen((event) {
      final bool isNearNow = event > 0;
      if (isNearNow) {
        if (_isNear) return;

        _isNear = true;
        _holdStarted = true;

        onNearStarted?.call();

        _holdTimer?.cancel();
        _holdTimer = Timer(holdDuration, () {
          if (_isNear) {
            _holdStarted = false;
            onHoldCompleted();
          }
        });
      }
      else {
        _isNear = false;
        _holdTimer?.cancel();
        if (_holdStarted) {
          _holdStarted = false;
          onNearCancelled?.call();
        }
      }
    });
  }

  void stop() {
    _subscription?.cancel();
    _subscription = null;

    _holdTimer?.cancel();
    _holdTimer = null;

    _isNear = false;
    _holdStarted = false;
    _started = false;
  }
}