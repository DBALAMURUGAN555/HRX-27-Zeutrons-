// backend_url.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseURL = 'http://pollutionviz-3hta.onrender.com';

Future<Map<String, dynamic>?> fetchDashboardData() async {
  try {
    final response = await http.get(Uri.parse('$baseURL/get_location'));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['data']; // Return just the data part
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  } catch (e) {
    print('API Error: $e');
    return null;
  }
}

Future<Map<String, dynamic>?> fetchTrendsData({String range = "weekly"}) async {
  try {
    final response = await http.get(
      Uri.parse('$baseURL/get_trends?range=$range'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData; // Return the entire response
    } else {
      throw Exception('Failed to load trends data: ${response.statusCode}');
    }
  } catch (e) {
    print('Trends API Error: $e');
    return null;
  }
}
