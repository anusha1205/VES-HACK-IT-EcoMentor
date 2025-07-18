import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'aqi_details_dialog.dart';
import 'api_service.dart';
import 'aqi_constants.dart';
import 'cities_data.dart';

class AQIMapScreen extends StatefulWidget {
  const AQIMapScreen({super.key});

  @override
  _AQIMapScreenState createState() => _AQIMapScreenState();
}

class _AQIMapScreenState extends State<AQIMapScreen> {
  final ApiService apiService = ApiService();
  final List<Marker> _markers = [];
  bool _isLoading = true;
  final MapController _mapController = MapController();
  LatLng? _userLocation;
  bool _locationFetched = false;
// ✅ Show AQI Dialog at Marker Click
  void _showAQIDialogAtMarker(BuildContext context, Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: AQIDetailsDialog(cityData: data),
      ),
    );
  }

  // ✅ Load AQI Markers for Cities
  Future<void> _loadMarkers() async {
    for (var city in CitiesData.cities) {
      try {
        final data = await apiService.fetchAQIData(city['lat'], city['lon']);
        _markers.add(
          Marker(
            point: LatLng(city['lat'], city['lon']),
            width: 30,
            height: 25,
            child: GestureDetector(
              onTap: () => _showAQIDialogAtMarker(context, data),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color:
                      AQIConstants.getAQIColor(data['list'][0]['main']['aqi']),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    "${data['list'][0]['main']['aqi']}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                ),
              ),
            ),
          ),
        );
      } catch (e) {
        print('Error fetching AQI data for ${city['name']}: $e');
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  // ✅ Fetch & Show Nearest AQI City Data
  void _showNearestCityAQI() async {
    if (_userLocation == null) return;

    LatLng? nearestCity;
    double minDistance = double.infinity;
    Map<String, dynamic>? nearestCityData;

    for (var city in CitiesData.cities) {
      double distance = Geolocator.distanceBetween(_userLocation!.latitude,
          _userLocation!.longitude, city['lat'], city['lon']);

      if (distance < minDistance) {
        minDistance = distance;
        nearestCity = LatLng(city['lat'], city['lon']);
        nearestCityData = city;
      }
    }

    if (nearestCityData != null) {
      try {
        final data = await apiService.fetchAQIData(
            nearestCity!.latitude, nearestCity.longitude);
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AQIDetailsDialog(cityData: data),
          );
        }
      } catch (e) {
        print("Error fetching AQI data: $e");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadMarkers();
    _checkAndRequestLocation();
  }

  // ✅ Check and Request Location Permissions
  Future<void> _checkAndRequestLocation() async {
    try {
      await _determinePosition();
    } catch (e) {
      print("Error in _checkAndRequestLocation: $e");
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get current position with the correct parameter format
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  // ✅ Get User's Current Location & Add Blue Pin
  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
        _locationFetched = true;
        _mapController.move(
            _userLocation!, 12.0); // ✅ Adjust zoom after finding location
      });

      _addUserMarker();
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  // ✅ Add Blue Pin for User's Location
  void _addUserMarker() {
    if (_userLocation != null) {
      setState(() {
        _markers.removeWhere((marker) => marker.point == _userLocation);

        _markers.add(
          Marker(
            point: _userLocation!,
            width: 50,
            height: 50,
            child: GestureDetector(
              onTap: _showNearestCityAQI,
              child:
                  const Icon(Icons.location_pin, color: Colors.blue, size: 50),
            ),
          ),
        );
      });
    }
  }

  // ✅ Show Dialog if Location Services Are Disabled
  void _showLocationDisabledDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Location Disabled"),
        content: const Text(
            "Please enable location services in your device settings."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  // ✅ Show Dialog if Location Permissions Are Denied
  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Permission Denied"),
        content: const Text(
            "Location permissions are permanently denied. Please enable them in settings."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AQI Map"),
        backgroundColor: Color(0xFF1E4B5F), // ✅ Uses theme color
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _userLocation ?? LatLng(20.5937, 78.9629),
              minZoom:
                  2.5, // ✅ Allows zooming out to level 5 (adjust as needed)
              maxZoom: 10.0, // ✅ Allows zooming in up to level 18
              initialZoom: 14.0, // ✅ Sets a balanced starting zoom

              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.pinchZoom |
                    InteractiveFlag.drag, // Allows zoom & pan only
              ),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png",
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(markers: _markers),
            ],
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton.extended(
              onPressed: _checkAndRequestLocation, // ✅ Ensures location updates
              backgroundColor: Color(0xFF1E4B5F), // ✅ Sets primary theme color
              foregroundColor: Colors.white, // ✅ Ensures text/icon visibility
              icon: const Icon(Icons.my_location),
              label: const Text("Find My Location"),
            ),
          ),
        ],
      ),
    );
  }
}
