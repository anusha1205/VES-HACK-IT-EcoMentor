import 'package:flutter/material.dart';

class AQIConstants {
  static Color getAQIColor(int aqi) {
    if (aqi == 1) return Colors.green;
    if (aqi == 2) return Colors.yellow;
    if (aqi == 3) return Colors.orange;
    if (aqi == 4) return Colors.red;
    if (aqi == 5) return Colors.purple;
    return Colors.grey;
  }

  static String getAQIStatus(int aqi) {
    if (aqi == 1) return "Good";
    if (aqi == 2) return "Fair";
    if (aqi == 3) return "Moderate";
    if (aqi == 4) return "Poor";
    if (aqi == 5) return "Very Poor";
    return "Unknown";
  }
}
