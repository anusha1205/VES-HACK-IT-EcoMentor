import 'package:flutter/material.dart';
import 'cities_data.dart'; // ✅ Import Cities Data
import 'med_data.dart'; // ✅ Import Medical Threshold Data
import 'api_service.dart'; // ✅ Import API Service

class CitySafetyChecker extends StatefulWidget {
  const CitySafetyChecker({super.key});

  @override
  _CitySafetyCheckerState createState() => _CitySafetyCheckerState();
}

class _CitySafetyCheckerState extends State<CitySafetyChecker> {
  final ApiService apiService = ApiService();
  String? selectedCity;
  String? selectedDisease;
  String resultMessage = "";
  bool isLoading = false;

  // ✅ Function to Check Safety of Selected City for the Selected Disease
  Future<void> checkCitySafety() async {
    if (selectedCity == null || selectedDisease == null) {
      setState(() {
        resultMessage = "Please select a city and a disease.";
      });
      return;
    }

    setState(() {
      isLoading = true;
      resultMessage = "Fetching data...";
    });

    // ✅ Get Selected City's Coordinates
    var cityData = CitiesData.cities.firstWhere(
      (city) => city["name"] == selectedCity,
      orElse: () => <String, dynamic>{},
    );

    if (cityData.isEmpty) {
      setState(() {
        resultMessage = "No data available for $selectedCity.";
        isLoading = false;
      });
      return;
    }

    double lat = cityData["lat"];
    double lon = cityData["lon"];

    try {
      // ✅ Fetch Real-time AQI Data
      var apiResponse = await apiService.fetchAQIData(lat, lon);
      var pollutantData = apiResponse["list"][0]["components"]; // Extract pollutants

      // ✅ Fetch Disease-Specific Pollutant Thresholds
      var diseaseData = medData.firstWhere(
        (disease) => disease["disease"] == selectedDisease,
        orElse: () => <String, dynamic>{},
      );

      if (diseaseData.isEmpty) {
        setState(() {
          resultMessage = "No data available for $selectedDisease.";
          isLoading = false;
        });
        return;
      }

      // ✅ Compare Each Pollutant with Disease Thresholds
      bool isSafe = true;
      String exceededPollutants = "";

      for (var pollutant in diseaseData["pollutants"]) {
        String key = pollutant["key"]; // API pollutant key
        double threshold = pollutant["value"].toDouble(); // Threshold value

        if (pollutantData.containsKey(key)) {
          double actualValue = pollutantData[key].toDouble();
          if (actualValue > threshold) {
            isSafe = false;
            exceededPollutants += "$key ($actualValue µg/m³ > $threshold µg/m³)\n";
          }
        }
      }

      // ✅ Generate Result Message
      if (isSafe) {
        resultMessage = "$selectedCity is **SAFE** for people with $selectedDisease.";
      } else {
        resultMessage =
            "$selectedCity is **NOT SAFE** for people with $selectedDisease.\n\nExceeded Levels:\n$exceededPollutants";
      }
    } catch (e) {
      resultMessage = "Failed to fetch AQI data. Please try again.";
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("City Safety Checker"), backgroundColor: Color(0xFF1E4B5F)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ✅ City Dropdown
            const Text("Select a City", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(border: OutlineInputBorder()),
              value: selectedCity,
              items: CitiesData.cities.map<DropdownMenuItem<String>>((city) {
                return DropdownMenuItem<String>(
                  value: city["name"] as String,
                  child: Text(city["name"] as String),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedCity = value),
            ),

            const SizedBox(height: 20),

            // ✅ Disease Dropdown
            const Text("Select a Disease", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(border: OutlineInputBorder()),
              value: selectedDisease,
              items: medData.map<DropdownMenuItem<String>>((disease) {
                return DropdownMenuItem<String>(
                  value: disease["disease"] as String,
                  child: Text(disease["disease"] as String),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedDisease = value),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: checkCitySafety,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Check Safety"),
            ),

            const SizedBox(height: 20),

            Text(resultMessage, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
