// models/dashboard_data.dart
class DashboardData {
  final String city;
  final List<double> coordinates;
  final String date;
  final double temperature;
  final String weatherDescription;
  final int aqi;
  final String aqiStatus;
  final double pm25;
  final double pm10;
  final double no2;
  final double co;
  final double o3;

  DashboardData({
    required this.city,
    required this.coordinates,
    required this.date,
    required this.temperature,
    required this.weatherDescription,
    required this.aqi,
    required this.aqiStatus,
    required this.pm25,
    required this.pm10,
    required this.no2,
    required this.co,
    required this.o3,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    final location = json['location'];
    final weather = json['weather'];
    final pollution = json['pollution'];

    return DashboardData(
      city: location['city'],
      coordinates: List<double>.from(location['coordinates']),
      date: json['date'],
      temperature: weather['temp'].toDouble(),
      weatherDescription: weather['description'],
      aqi: pollution['aqi'],
      aqiStatus: pollution['aqi_status'],
      pm25: pollution['pm25'].toDouble(),
      pm10: pollution['pm10'].toDouble(),
      no2: pollution['no2'].toDouble(),
      co: pollution['co'].toDouble(),
      o3: pollution['o3'].toDouble(),
    );
  }
}

/// models/trends_data.dart
class TrendsData {
  final String range;
  final List<TrendsMeasurement> data;
  final Map<String, String> units;
  final String? improvement; // Only for yearly data

  TrendsData({
    required this.range,
    required this.data,
    required this.units,
    this.improvement,
  });

  factory TrendsData.fromJson(Map<String, dynamic> json) {
    return TrendsData(
      range: json['range'],
      data: (json['data'] as List)
          .map((item) => TrendsMeasurement.fromJson(item, json['range']))
          .toList(),
      units: Map<String, String>.from(json['units']),
      improvement: json['improvement'], // Will be null for weekly/monthly
    );
  }
}

class TrendsMeasurement {
  final String date;
  final double pm25;
  final double pm10;
  final double no2;
  final double co;
  final double o3;
  final String? improvement; // Only for yearly data

  TrendsMeasurement({
    required this.date,
    required this.pm25,
    required this.pm10,
    required this.no2,
    required this.co,
    required this.o3,
    this.improvement,
  });

  factory TrendsMeasurement.fromJson(Map<String, dynamic> json, String range) {
    // Handle different field names based on range
    final pm25 = (json['pm25'] ?? json['avg_pm25'])?.toDouble() ?? 0.0;
    final pm10 = (json['pm10'] ?? json['avg_pm10'])?.toDouble() ?? 0.0;
    final no2 = (json['no2'] ?? json['avg_no2'])?.toDouble() ?? 0.0;
    final co = (json['co'] ?? json['avg_co'])?.toDouble() ?? 0.0;
    final o3 = (json['o3'] ?? json['avg_o3'])?.toDouble() ?? 0.0;

    // Determine the date field based on range
    String date;
    if (range == 'weekly') {
      date = json['date'];
    } else if (range == 'monthly') {
      date = json['month'];
    } else {
      date = json['year'];
    }

    return TrendsMeasurement(
      date: date,
      pm25: pm25,
      pm10: pm10,
      no2: no2,
      co: co,
      o3: o3,
      improvement: json['improvement'],
    );
  }
}

