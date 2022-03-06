import 'dart:async';

import 'package:flutter/material.dart';

class TimerProvider extends ChangeNotifier {
  TimerProvider({required this.duration}) {
    timer = Timer.periodic(duration, onTimerCallback);
  }

  Duration duration;
  Timer? timer;

  void stopTimer() {
    timer?.cancel();
  }

  void onTimerCallback(Timer timer) {
    if (timer.isActive) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    stopTimer();
  }
}
