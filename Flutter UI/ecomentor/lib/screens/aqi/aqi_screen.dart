import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'aqi_map_screen.dart'; // Ensure the correct path
import 'city_safety_checker.dart';

class AQIScreen extends StatelessWidget {
  const AQIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: AppBar(
        title: Text(
          'Air Quality Index',
          style: AppTextStyles.h3.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // AQI Information Section at the top
              Text('Understanding AQI & Climate Change', style: AppTextStyles.h3),
              const SizedBox(height: 16),
              _buildAQIInfoSection(),

              Text('Health Recommendations', style: AppTextStyles.h3),
              const SizedBox(height: 16),
              _buildHealthRecommendations(),

              const SizedBox(height: 24),
              Text('City Safety Checker', style: AppTextStyles.h3),
              const SizedBox(height: 16),
              _buildCitySafetyCheckerCard(context),

              const SizedBox(height: 24),
              Text('Real-time AQI Map', style: AppTextStyles.h3),
              const SizedBox(height: 16),
              _buildAQIMapPreview(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAQIMapPreview(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AQIMapScreen()),
        );
      },
      child: Card(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 200,
                width: double.infinity,
                child: FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(20.5937, 78.9629),
                    initialZoom: 3.5,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.none, // Disables interactions
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png",
                      subdomains: const ['a', 'b', 'c'],
                    ),
                  ],
                ),
              ),
              Container(
                height: 200,
                width: double.infinity,
                color: Colors.black.withOpacity(0.3), 
                alignment: Alignment.center,
                child: Text(
                  "Tap to View Full Map",
                  style: AppTextStyles.h3.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCitySafetyCheckerCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CitySafetyChecker()),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      "Find out if a city is safe for people with specific health conditions based on air quality.",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.health_and_safety, color: AppColors.primary, size: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAQIInfoSection() {
    // Updated list to include an icon key (type: IconData)
    final List<Map<String, dynamic>> aqiInfo = [
      {
        "title": "What is AQI?",
        "description":
            "AQI (Air Quality Index) measures air pollution levels. A lower AQI means cleaner air, while a higher AQI can be harmful to health.",
        "icon": Icons.info_outline, // Suggestion: Info icon
      },
      {
        "title": "How is AQI linked to climate change?",
        "description":
            "Air pollution contributes to climate change by trapping heat and altering weather patterns. Reducing emissions helps both air quality and the climate.",
        "icon": Icons.cloud, // Suggestion: Cloud icon
      },
      {
        "title": "Tips for Better Air Quality",
        "description":
            "🚶 Walk, cycle, or use public transport.\n🌱 Plant more trees.\n🚗 Reduce car emissions.\n🏡 Use air purifiers indoors.",
        "icon": Icons.tips_and_updates, // Suggestion: Lightbulb/Tips icon
      },
      {
        "title": "How Can You Help?",
        "description":
            "Support clean energy, use less plastic, and spread awareness. Every small action contributes to a healthier planet.",
        "icon": Icons.volunteer_activism, // Suggestion: Volunteer icon
      },
    ];

    // Instead of a fixed height, allow horizontal scrolling + flexible height
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: aqiInfo.map((item) => _buildAQICard(item)).toList(),
      ),
    );
  }

  Widget _buildAQICard(Map<String, dynamic> item) {
    // Extract the icon from the map
    final iconData = item["icon"] as IconData;

    return Container(
      // Fixed width for consistent card sizes (optional)
      width: 270,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min, // let the card height match content
            children: [
              // Icon at the top
              Icon(
                iconData,
                size: 40,
                color: AppColors.primary,
              ),
              const SizedBox(height: 10),
              // Title
              Text(
                item["title"] ?? "",
                style: AppTextStyles.h3.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Body text
              Text(
                item["description"] ?? "",
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
/// Add this method in your AQIScreen class:
Widget _buildHealthRecommendations() {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildRecommendationItem(
            icon: Icons.directions_walk,
            title: 'Outdoor Activities',
            description: 'Safe for outdoor activities and exercise',
          ),
          const Divider(),
          _buildRecommendationItem(
            icon: Icons.window,
            title: 'Ventilation',
            description: 'Open windows to let in fresh air',
          ),
          const Divider(),
          _buildRecommendationItem(
            icon: Icons.masks,
            title: 'Masks',
            description: 'No masks needed for the general population',
          ),
        ],
      ),
    ),
  );
}

/// Helper method for building each recommendation row
Widget _buildRecommendationItem({
  required IconData icon,
  required String title,
  required String description,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      children: [
        // Circle background with icon
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 16),
        // Title & description
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
