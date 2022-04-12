import 'dart:async';

import 'package:flutter/material.dart';

/// A provider which periodically [notifyListeners] every set [duration].
class TimerProvider extends ChangeNotifier {
  /// Initialises [timer] with a [Timer.periodic] with interval of [duration].
  TimerProvider({required this.duration}) {
    timer = Timer.periodic(duration, onTimerCallback);
  }

  /// The duration of the [timer] interval.
  Duration duration;

  /// The [Timer.periodic] which [notifyListeners].
  Timer? timer;

  /// Stops the timer.
  void stopTimer() {
    timer?.cancel();
  }

  /// Called every time the [timer] [duration] is reached.
  void onTimerCallback(Timer timer) {
    if (timer.isActive) {
      notifyListeners();
    }
  }

  /// Stop the timer when this instance is [dispose] of.
  @override
  void dispose() {
    super.dispose();
    stopTimer();
  }
}
