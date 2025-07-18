import 'package:flutter/material.dart';
import 'aqi_constants.dart';
import 'aqi_info.dart'; // ✅ Import the new AQI Info file

class AQIDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> cityData;

  const AQIDetailsDialog({super.key, required this.cityData});

  @override
  Widget build(BuildContext context) {
    final int aqi = cityData['list'][0]['main']['aqi'];
    final components = cityData['list'][0]['components'];
    final Color aqiColor = AQIConstants.getAQIColor(aqi);
    final String aqiStatus = AQIConstants.getAQIStatus(aqi);

    return Dialog(
      insetPadding: EdgeInsets.zero, // ✅ Removes default padding to make it full-screen
      backgroundColor: Colors.transparent, // ✅ Removes background color for full-width effect
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width, // ✅ Full width
            height: MediaQuery.of(context).size.height * 0.9, // ✅ 90% of screen height
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView( // ✅ Makes content scrollable
              child: Padding(
                padding: const EdgeInsets.all(16), // ✅ Reduced padding for better text visibility
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ AQI Status Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: aqiColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: aqiColor, width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "AQI: $aqi",
                            style: TextStyle(
                              fontSize: 28, // ✅ Larger text for better readability
                              fontWeight: FontWeight.bold,
                              color: aqiColor,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            aqiStatus,
                            style: TextStyle(
                              fontSize: 20, // ✅ Bigger font
                              fontWeight: FontWeight.w600,
                              color: aqiColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ✅ Pollutant Levels with Tooltips
                    const Text(
                      "Pollutant Levels (Tap ℹ for info)",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const Divider(thickness: 2),

                    _buildPollutantRow(context, "CO", components['co']),
                    _buildPollutantRow(context, "NO2", components['no2']),
                    _buildPollutantRow(context, "O3", components['o3']),
                    _buildPollutantRow(context, "PM2.5", components['pm2_5']),
                    _buildPollutantRow(context, "PM10", components['pm10']),
                    _buildPollutantRow(context, "SO2", components['so2']),

                    const SizedBox(height: 20),

                    // ✅ How is AQI Calculated? (Expandable Section)
                    AQIInfo.aqiCalculationInfo(),

                    const SizedBox(height: 20),

                    // ✅ Close Button
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: aqiColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Close", style: TextStyle(color: Colors.white, fontSize: 18)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Pollutant Row With Tooltips & Info Icon
  Widget _buildPollutantRow(BuildContext context, String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12), // ✅ Reduced padding
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500), // ✅ Bigger text
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () => AQIInfo.showPollutantInfo(context, label.split(" ")[0]),
                  child: const Icon(Icons.info_outline, color: Colors.blueGrey, size: 22), // ✅ Bigger info icon
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value.toStringAsFixed(2),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87), // ✅ Bigger font
          ),
        ],
      ),
    );
  }
}
