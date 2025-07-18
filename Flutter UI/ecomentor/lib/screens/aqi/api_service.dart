import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/air_pollution';
  final String apiKey = '76218c4354d8c2cf73ef910e85e5cf3c';

  Future<Map<String, dynamic>> fetchAQIData(double lat, double lon) async {
    final response = await http.get(
      Uri.parse('$baseUrl?lat=$lat&lon=$lon&appid=$apiKey'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch AQI data');
    }
  }
}
