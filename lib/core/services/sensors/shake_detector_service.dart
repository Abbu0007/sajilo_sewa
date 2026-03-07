import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';

class ShakeDetectorService {
  ShakeDetectorService._();
  static final ShakeDetectorService instance = ShakeDetectorService._();

  StreamSubscription<AccelerometerEvent>? _subscription;
  DateTime? _lastTriggerTime;
  DateTime? _lastShakeHitTime;

  bool _started = false;
  int _shakeCount = 0;

  void start({
    required void Function() onShake,
    double threshold = 20.0,
    int requiredShakeCount = 4,
    Duration shakeWindow = const Duration(milliseconds: 1000),
    Duration minGap = const Duration(milliseconds: 2200),
  }) {
    if (_started) return;
    _started = true;

    _subscription = accelerometerEventStream().listen((event) {
      final magnitude = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );

      final now = DateTime.now();

      if (magnitude < threshold) return;

      if (kDebugMode) {
        print(
          "Strong motion => "
          "x:${event.x.toStringAsFixed(2)}, "
          "y:${event.y.toStringAsFixed(2)}, "
          "z:${event.z.toStringAsFixed(2)}, "
          "mag:${magnitude.toStringAsFixed(2)}",
        );
      }

      if (_lastTriggerTime != null &&
          now.difference(_lastTriggerTime!) < minGap) {
        return;
      }

      if (_lastShakeHitTime == null ||
          now.difference(_lastShakeHitTime!) > shakeWindow) {
        _shakeCount = 0;
      }

      _lastShakeHitTime = now;
      _shakeCount++;

      if (kDebugMode) {
        print("Shake hit count: $_shakeCount / $requiredShakeCount");
      }

      if (_shakeCount >= requiredShakeCount) {
        _lastTriggerTime = now;
        _shakeCount = 0;

        if (kDebugMode) {
          print("SHAKE DETECTED");
        }

        onShake();
      }
    });
  }

  void stop() {
    _subscription?.cancel();
    _subscription = null;
    _lastTriggerTime = null;
    _lastShakeHitTime = null;
    _shakeCount = 0;
    _started = false;
  }
}