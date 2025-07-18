import 'dart:async';
import 'package:flutter/material.dart';

class TimerUtils {
  static Timer startCountdown(int duration, Function(int) onTick, Function onEnd) {
    int timeLeft = duration;
    return Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        timeLeft--;
        onTick(timeLeft);
      } else {
        timer.cancel();
        onEnd();
      }
    });
  }

  static Widget buildTimerBar(int timeLeft, int totalTime) {
    return LinearProgressIndicator(
      value: timeLeft / totalTime,
      backgroundColor: Colors.grey[200],
      valueColor: AlwaysStoppedAnimation<Color>(timeLeft > 10 ? Colors.green : Colors.red),
    );
  }
}
