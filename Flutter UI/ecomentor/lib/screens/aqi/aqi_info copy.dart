import 'package:flutter/material.dart';

class AQIInfo {
  // ✅ Tooltip Information for Each Pollutant
  static Map<String, String> pollutantDescriptions = {
    "CO": "Carbon Monoxide: Produced by cars and burning fuels. Reduces oxygen in blood.",
    "NO2": "Nitrogen Dioxide: Emitted from vehicles & industry. Causes lung irritation.",
    "O3": "Ozone: Good in stratosphere, bad near the ground. Can cause breathing issues.",
    "PM2.5": "Fine Particulate Matter: Tiny particles that penetrate lungs, affecting health.",
    "PM10": "Coarse Particulate Matter: Dust & pollutants that can cause respiratory issues.",
    "SO2": "Sulfur Dioxide: Produced by burning fossil fuels. Causes acid rain & breathing problems."
  };

  // ✅ Function to Show Tooltip Dialog on Tap
  static void showPollutantInfo(BuildContext context, String pollutant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          pollutant,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        content: Text(
          pollutantDescriptions[pollutant] ?? "No information available.",
          textAlign: TextAlign.justify,
          style: const TextStyle(fontSize: 18, height: 1.5),
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close", style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Expandable Section: "How is AQI Calculated?"
  static Widget aqiCalculationInfo() {
  return Card(
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: ExpansionTile(
      title: const Text(
        "How is AQI Calculated?",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "The Air Quality Index (AQI) is calculated based on the concentration of key pollutants in the air. "
                "It converts raw pollutant concentration into a standardized AQI value using breakpoints and linear scaling.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 12),

              // ✅ List of Pollutants Used in AQI Calculation
              _infoText("PM2.5 & PM10 → Particulate matter that affects lung health."),
              _infoText("O₃ (Ozone) → Harmful at ground level, causes respiratory issues."),
              _infoText("CO (Carbon Monoxide) → Reduces oxygen in the bloodstream."),
              _infoText("NO₂ (Nitrogen Dioxide) → Worsens asthma & lung diseases."),
              _infoText("SO₂ (Sulfur Dioxide) → Leads to acid rain & breathing problems."),
              const SizedBox(height: 16),

              // ✅ Mathematical Calculation Explanation
              const Text(
                "📌 AQI Calculation Formula",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Each pollutant is assigned an individual AQI using the formula:",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 8),
              const Text(
                "     AQI = [(I_high - I_low) / (C_high - C_low)] * (C - C_low) + I_low",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // ✅ Explanation of AQI Formula Components
              _infoText("C → Measured pollutant concentration"),
              _infoText("C_low & C_high → Lower and upper concentration breakpoints"),
              _infoText("I_low & I_high → Corresponding AQI values for breakpoints"),
              const SizedBox(height: 16),

              // ✅ Final AQI Determination
              const Text(
                "The highest AQI value among all pollutants is reported as the final AQI for that location.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


  // ✅ Helper Function for Bullet Points
  static Widget _infoText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, height: 1.5),
        textAlign: TextAlign.justify,
      ),
    );
  }
}
