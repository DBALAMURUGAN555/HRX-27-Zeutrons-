import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'backend_url.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'datamodels.dart';

const String baseURL = 'http://pollutionviz-3hta.onrender.com';

class InsightsPage extends StatefulWidget {
  const InsightsPage({super.key});

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  late Future<Map<String, dynamic>?> _dashboardData;
  late Future<TrendsData> _trendsData;
  String _selectedRange = 'weekly';

  @override
  void initState() {
    super.initState();
    _dashboardData = fetchDashboardData();
    _trendsData = _fetchTrendsData(_selectedRange);
  }

  Future<TrendsData> _fetchTrendsData(String range) async {
    try {
      final response = await http.get(
        Uri.parse('$baseURL/getTrends?range=$range'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return TrendsData.fromJson(jsonData);
      } else {
        return _getStaticTrendsData(range);
      }
    } catch (e) {
      return _getStaticTrendsData(range);
    }
  }

  TrendsData _getStaticTrendsData(String range) {
    if (range == 'weekly') {
      return TrendsData(
        range: 'weekly',
        data: [
          TrendsMeasurement(
            date: "2025-06-26",
            pm25: 112,
            pm10: 46,
            no2: 33.6,
            co: 0.896,
            o3: 28,
          ),
          TrendsMeasurement(
            date: "2025-06-27",
            pm25: 125,
            pm10: 47,
            no2: 37.5,
            co: 1,
            o3: 31.2,
          ),
          TrendsMeasurement(
            date: "2025-06-28",
            pm25: 138,
            pm10: 57,
            no2: 41.4,
            co: 1.104,
            o3: 34.5,
          ),
          TrendsMeasurement(
            date: "2025-06-29",
            pm25: 99,
            pm10: 47,
            no2: 29.7,
            co: 0.792,
            o3: 24.8,
          ),
          TrendsMeasurement(
            date: "2025-06-30",
            pm25: 95,
            pm10: 47,
            no2: 28.5,
            co: 0.76,
            o3: 23.8,
          ),
          TrendsMeasurement(
            date: "2025-07-01",
            pm25: 139,
            pm10: 66,
            no2: 41.7,
            co: 1.112,
            o3: 34.8,
          ),
          TrendsMeasurement(
            date: "2025-07-02",
            pm25: 139,
            pm10: 68,
            no2: 41.7,
            co: 1.112,
            o3: 34.8,
          ),
        ],
        units: {
          "pm25": "µg/m³",
          "pm10": "µg/m³",
          "no2": "ppb",
          "co": "ppm",
          "o3": "ppb",
        },
      );
    } else if (range == 'monthly') {
      return TrendsData(
        range: 'monthly',
        data: [
          TrendsMeasurement(
            date: "2024-08",
            pm25: 99.9,
            pm10: 42.9,
            no2: 30.0,
            co: 10.0,
            o3: 20.0,
          ),
          TrendsMeasurement(
            date: "2024-09",
            pm25: 81.4,
            pm10: 34.9,
            no2: 24.4,
            co: 8.1,
            o3: 16.3,
          ),
          TrendsMeasurement(
            date: "2024-10",
            pm25: 78.2,
            pm10: 33.5,
            no2: 23.4,
            co: 7.8,
            o3: 15.6,
          ),
          TrendsMeasurement(
            date: "2024-11",
            pm25: 90.6,
            pm10: 38.8,
            no2: 27.2,
            co: 9.1,
            o3: 18.1,
          ),
          TrendsMeasurement(
            date: "2024-12",
            pm25: 87.4,
            pm10: 37.5,
            no2: 26.2,
            co: 8.7,
            o3: 17.5,
          ),
          TrendsMeasurement(
            date: "2025-01",
            pm25: 110.2,
            pm10: 47.2,
            no2: 33.1,
            co: 11.0,
            o3: 22.0,
          ),
          TrendsMeasurement(
            date: "2025-02",
            pm25: 136.9,
            pm10: 58.7,
            no2: 41.1,
            co: 13.7,
            o3: 27.4,
          ),
          TrendsMeasurement(
            date: "2025-03",
            pm25: 134.3,
            pm10: 57.6,
            no2: 40.3,
            co: 13.4,
            o3: 26.9,
          ),
          TrendsMeasurement(
            date: "2025-04",
            pm25: 154.6,
            pm10: 66.3,
            no2: 46.4,
            co: 15.5,
            o3: 30.9,
          ),
          TrendsMeasurement(
            date: "2025-05",
            pm25: 129.8,
            pm10: 55.6,
            no2: 38.9,
            co: 13.0,
            o3: 26.0,
          ),
          TrendsMeasurement(
            date: "2025-06",
            pm25: 113.8,
            pm10: 48.8,
            no2: 39.3,
            co: 13.1,
            o3: 26.2,
          ),
        ],
        units: {
          "pm25": "µg/m³",
          "pm10": "µg/m³",
          "no2": "ppb",
          "co": "ppm",
          "o3": "ppb",
        },
      );
    } else {
      return TrendsData(
        range: 'yearly',
        data: [
          TrendsMeasurement(
            date: "2021",
            pm25: 112.8,
            pm10: 48.4,
            no2: 34.0,
            co: 11.3,
            o3: 22.7,
            improvement: "0.0%",
          ),
          TrendsMeasurement(
            date: "2022",
            pm25: 110.6,
            pm10: 47.4,
            no2: 33.3,
            co: 11.1,
            o3: 22.2,
            improvement: "1.0%",
          ),
          TrendsMeasurement(
            date: "2023",
            pm25: 105.8,
            pm10: 45.4,
            no2: 31.8,
            co: 10.6,
            o3: 21.2,
            improvement: "2.0%",
          ),
          TrendsMeasurement(
            date: "2024",
            pm25: 107.7,
            pm10: 46.2,
            no2: 32.4,
            co: 10.8,
            o3: 21.6,
            improvement: "3.0%",
          ),
          TrendsMeasurement(
            date: "2025",
            pm25: 108.0,
            pm10: 46.3,
            no2: 32.5,
            co: 10.8,
            o3: 21.7,
            improvement: "4.0%",
          ),
        ],
        units: {
          "pm25": "µg/m³",
          "pm10": "µg/m³",
          "no2": "ppb",
          "co": "ppm",
          "o3": "ppb",
        },
      );
    }
  }

  void _onRangeChanged(String newRange) {
    setState(() {
      _selectedRange = newRange;
      _trendsData = _fetchTrendsData(newRange);
    });
  }

  Color _getAqiColor(int aqi) {
    if (aqi <= 50) return Colors.green;
    if (aqi <= 100) return Colors.yellow;
    if (aqi <= 150) return Colors.orange;
    if (aqi <= 200) return Colors.red;
    if (aqi <= 300) return Colors.purple;
    return Colors.deepPurple.shade900;
  }

  String _getHealthAdvisory(int aqi) {
    if (aqi <= 50) return 'Air quality is satisfactory.';
    if (aqi <= 100) return 'Moderate health concern for sensitive groups.';
    if (aqi <= 150) return 'Unhealthy for sensitive groups.';
    if (aqi <= 200) return 'Unhealthy for everyone.';
    if (aqi <= 300) return 'Very unhealthy with health warnings.';
    return 'Hazardous conditions - avoid outdoor activities.';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FutureBuilder<Map<String, dynamic>?>(
      future: _dashboardData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Failed to load data'),
                ElevatedButton(
                  onPressed: () => setState(() {
                    _dashboardData = fetchDashboardData();
                  }),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final data = snapshot.data!;
        final location = data['location'];
        final pollution = data['pollution'];
        final weather = data['weather'];

        final regionAqiList = [
          RegionAqi(
            name: "South Delhi",
            aqi: (pollution['aqi'] * 1.1).round(),
            trend: "↓ 17% lower",
            color: Colors.orange,
            trendColor: Colors.green,
          ),
          RegionAqi(
            name: "Gurgaon",
            aqi: (pollution['aqi'] * 0.9).round(),
            trend: "↓ 24% lower",
            color: Colors.yellow,
            trendColor: Colors.green,
          ),
          RegionAqi(
            name: "East Delhi",
            aqi: (pollution['aqi'] * 1.3).round(),
            trend: "↑ 5% higher",
            color: Colors.red,
            trendColor: Colors.red,
          ),
        ];

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Insights',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 18,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        location['city'] ?? 'Unknown Location',
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          color: isDark ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '• ${data['date'] ?? 'Unknown Date'}',
                        style: GoogleFonts.montserrat(
                          fontSize: 13,
                          color: isDark ? Colors.white54 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _TrendsTab(
                      label: 'Weekly',
                      selected: _selectedRange == 'weekly',
                      onTap: () => _onRangeChanged('weekly'),
                    ),
                    _TrendsTab(
                      label: 'Monthly',
                      selected: _selectedRange == 'monthly',
                      onTap: () => _onRangeChanged('monthly'),
                    ),
                    _TrendsTab(
                      label: 'Yearly',
                      selected: _selectedRange == 'yearly',
                      onTap: () => _onRangeChanged('yearly'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _PollutantCard(
                    label: 'PM2.5',
                    value: pollution['pm25'].toStringAsFixed(1),
                    unit: 'µg/m³',
                    color: Colors.red.shade100,
                    icon: Icons.cloud,
                    trend: '↑ 12% vs yesterday',
                    trendColor: Colors.red,
                  ),
                  _PollutantCard(
                    label: 'PM10',
                    value: pollution['pm10'].toStringAsFixed(1),
                    unit: 'µg/m³',
                    color: Colors.orange.shade100,
                    icon: Icons.cloud,
                    trend: '↑ 8% vs yesterday',
                    trendColor: Colors.orange,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _PollutantCard(
                    label: 'NO₂',
                    value: pollution['no2'].toStringAsFixed(1),
                    unit: 'ppb',
                    color: Colors.yellow.shade100,
                    icon: Icons.cloud,
                    trend: '↓ 3% vs yesterday',
                    trendColor: Colors.green,
                  ),
                  _PollutantCard(
                    label: 'O₃',
                    value: pollution['o3'].toStringAsFixed(1),
                    unit: 'ppb',
                    color: Colors.blue.shade100,
                    icon: Icons.cloud,
                    trend: '↓ 5% vs yesterday',
                    trendColor: Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CurrentAqiAdvisoryWidget(
                aqi: pollution['aqi'],
                status: pollution['aqi_status'],
                color: _getAqiColor(pollution['aqi']),
                advisory: _getHealthAdvisory(pollution['aqi']),
              ),
              const SizedBox(height: 24),
              FutureBuilder<TrendsData>(
                future: _trendsData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError || !snapshot.hasData) {
                    return const Text('Failed to load trends data');
                  }
                  return PollutionTrendsCard(trendsData: snapshot.data!);
                },
              ),
              RegionalComparisonCard(
                currentAqi: pollution['aqi'],
                location: location['city'] ?? 'Current Location',
                regions: regionAqiList,
              ),
              const HealthImpactAnalysisCard(),
            ],
          ),
        );
      },
    );
  }
}

// --- Current AQI + Health Advisory Widget (with blinking effect) ---
class CurrentAqiAdvisoryWidget extends StatefulWidget {
  final int aqi;
  final String status;
  final Color color;
  final String advisory;

  const CurrentAqiAdvisoryWidget({
    super.key,
    required this.aqi,
    required this.status,
    required this.color,
    required this.advisory,
  });

  @override
  State<CurrentAqiAdvisoryWidget> createState() =>
      _CurrentAqiAdvisoryWidgetState();
}

class _CurrentAqiAdvisoryWidgetState extends State<CurrentAqiAdvisoryWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _blink;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _blink = Tween<double>(
      begin: 1.0,
      end: 0.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // AQI tile with blinking
          AnimatedBuilder(
            animation: _blink,
            builder: (context, child) => Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(22),
                  topRight: Radius.circular(22),
                ),
              ),
              child: Opacity(
                opacity: _blink.value,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Current AQI',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Updated 10 minutes ago',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.aqi.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 36,
                          ),
                        ),
                        Text(
                          widget.status,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Health Advisory nested below AQI
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFFFF1F1),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(22),
                bottomRight: Radius.circular(22),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Health Advisory',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.advisory,
                        style: GoogleFonts.montserrat(
                          color: Colors.black87,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Pollutant Card ---
class _PollutantCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;
  final IconData icon;
  final String trend;
  final Color trendColor;

  const _PollutantCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.icon,
    required this.trend,
    required this.trendColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.of(context).size.width - 48) / 2,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: trendColor, size: 20),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            trend,
            style: TextStyle(
              color: trendColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Pollution Trends Section ---
class PollutionTrendsCard extends StatelessWidget {
  final TrendsData trendsData;

  const PollutionTrendsCard({super.key, required this.trendsData});

  @override
  Widget build(BuildContext context) {
    // Extract data for the chart
    final pm25Data = trendsData.data.map((m) => m.pm25).toList();
    final pm10Data = trendsData.data.map((m) => m.pm10).toList();
    final no2Data = trendsData.data.map((m) => m.no2).toList();
    final o3Data = trendsData.data.map((m) => m.o3).toList();

    // Create time labels based on range
    final timeLabels = trendsData.data.map((m) {
      if (trendsData.range == 'weekly') {
        return m.date.split('-').last; // Day for weekly (e.g., "26", "27")
      } else if (trendsData.range == 'monthly') {
        final parts = m.date.split('-');
        return '${parts[1]}/${parts[0].substring(2)}'; // MM/YY format
      } else {
        return m.date; // Year for yearly
      }
    }).toList();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade900
            : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          if (Theme.of(context).brightness == Brightness.light)
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${trendsData.range[0].toUpperCase()}${trendsData.range.substring(1)} Trends',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            width: double.infinity,
            child: PollutionTrendsGraph(
              pm25Data: pm25Data,
              pm10Data: pm10Data,
              no2Data: no2Data,
              o3Data: o3Data,
              timeLabels: timeLabels,
              units: trendsData.units,
              range: trendsData.range,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _LegendDot(color: Colors.green),
                const SizedBox(width: 4),
                Text(
                  'PM2.5 (${trendsData.units['pm25']})',
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(width: 12),
                _LegendDot(color: Colors.orange),
                const SizedBox(width: 4),
                Text(
                  'PM10 (${trendsData.units['pm10']})',
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(width: 12),
                _LegendDot(color: Colors.blue),
                const SizedBox(width: 4),
                Text(
                  'NO₂ (${trendsData.units['no2']})',
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(width: 12),
                _LegendDot(color: Colors.deepPurple),
                const SizedBox(width: 4),
                Text(
                  'O₃ (${trendsData.units['o3']})',
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PollutionTrendsGraph extends StatelessWidget {
  final List<double> pm25Data;
  final List<double> pm10Data;
  final List<double> no2Data;
  final List<double> o3Data;
  final List<String> timeLabels;
  final Map<String, String> units;
  final String range;

  const PollutionTrendsGraph({
    super.key,
    required this.pm25Data,
    required this.pm10Data,
    required this.no2Data,
    required this.o3Data,
    required this.timeLabels,
    required this.units,
    required this.range,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _TrendsGraphPainter(
        pm25Data: pm25Data,
        pm10Data: pm10Data,
        no2Data: no2Data,
        o3Data: o3Data,
        timeLabels: timeLabels,
        units: units,
        range: range,
      ),
      child: Container(),
    );
  }
}

class _TrendsGraphPainter extends CustomPainter {
  final List<double> pm25Data;
  final List<double> pm10Data;
  final List<double> no2Data;
  final List<double> o3Data;
  final List<String> timeLabels;
  final Map<String, String> units;
  final String range;

  _TrendsGraphPainter({
    required this.pm25Data,
    required this.pm10Data,
    required this.no2Data,
    required this.o3Data,
    required this.timeLabels,
    required this.units,
    required this.range,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate dynamic yMax based on the highest value in the data
    final allValues = [...pm25Data, ...pm10Data, ...no2Data, ...o3Data];
    double yMax = (allValues.reduce((a, b) => a > b ? a : b)) * 1.2;
    double yMin = 0;

    // Adjust yMax for CO if range is monthly/yearly (since CO values are higher)
    if (range != 'weekly') {
      yMax = (yMax * 1.5).roundToDouble();
    }

    final double leftPadding = 8;
    final double bottomPadding = 24;
    final double topPadding = 8;
    final double chartHeight = size.height - bottomPadding - topPadding;
    final double chartWidth = size.width - leftPadding;

    // Draw grid lines and y labels
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.15)
      ..strokeWidth = 1;

    final ySteps = 3;
    final yInterval = (yMax - yMin) / ySteps;
    final textStyle = TextStyle(color: Colors.grey.shade500, fontSize: 11);

    for (int i = 0; i <= ySteps; i++) {
      final y = topPadding + chartHeight - (chartHeight / ySteps) * i;
      canvas.drawLine(Offset(leftPadding, y), Offset(size.width, y), gridPaint);
      final label = (yMin + yInterval * i).toInt().toString();
      final tp = TextPainter(
        text: TextSpan(text: label, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(0, y - 7));
    }

    // Draw x labels
    final xCount = timeLabels.length;
    for (int i = 0; i < xCount; i++) {
      final x = leftPadding + (chartWidth) * i / (xCount - 1);
      final tp = TextPainter(
        text: TextSpan(
          text: timeLabels[i],
          style: TextStyle(color: Colors.grey.shade600, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(x - tp.width / 2, size.height - 18));
    }

    // Helper to plot a line
    void plotLine(List<double> data, Color color, {Color? fillColor}) {
      if (data.isEmpty) return;

      final points = <Offset>[];
      for (int i = 0; i < data.length; i++) {
        final x = leftPadding + (chartWidth) * i / (data.length - 1);
        final y =
            topPadding +
            chartHeight -
            ((data[i] - yMin) / (yMax - yMin)) * chartHeight;
        points.add(Offset(x, y));
      }
      final linePaint = Paint()
        ..color = color
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;

      final path = Path()..moveTo(points.first.dx, points.first.dy);
      for (final p in points.skip(1)) {
        path.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(path, linePaint);

      // Draw dots
      for (final p in points) {
        canvas.drawCircle(p, 3, Paint()..color = color);
      }

      // Fill area under curve if fillColor is provided
      if (fillColor != null) {
        final fillPath = Path()
          ..moveTo(points.first.dx, chartHeight + topPadding);
        for (final p in points) {
          fillPath.lineTo(p.dx, p.dy);
        }
        fillPath.lineTo(points.last.dx, chartHeight + topPadding);
        fillPath.close();
        canvas.drawPath(
          fillPath,
          Paint()
            ..color = fillColor.withOpacity(0.15)
            ..style = PaintingStyle.fill,
        );
      }
    }

    // Draw each pollutant line
    plotLine(pm10Data, Colors.orange, fillColor: Colors.orange);
    plotLine(pm25Data, Colors.green, fillColor: Colors.green);
    plotLine(no2Data, Colors.blue);
    plotLine(o3Data, Colors.deepPurple);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _TrendsTab extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  const _TrendsTab({required this.label, this.selected = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? Colors.green : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  const _LegendDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

// --- Regional Comparison Section ---
class RegionalComparisonCard extends StatelessWidget {
  final int currentAqi;
  final String location;
  final List<RegionAqi> regions;

  const RegionalComparisonCard({
    super.key,
    required this.currentAqi,
    required this.location,
    required this.regions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade900
            : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          if (Theme.of(context).brightness == Brightness.light)
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Regional Comparison',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 14),
          // Map placeholder with AQI
          Stack(
            children: [
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(14),
                  image: const DecorationImage(
                    image: AssetImage('assets/map_placeholder.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                left: 24,
                top: 40,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$currentAqi',
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your Location',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            location,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Region AQI List
          Column(
            children: regions.map((region) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: region.color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        region.aqi.toString(),
                        style: TextStyle(
                          color: region.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        region.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Text(
                      region.trend,
                      style: TextStyle(
                        color: region.trendColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class RegionAqi {
  final String name;
  final int aqi;
  final String trend;
  final Color color;
  final Color trendColor;

  RegionAqi({
    required this.name,
    required this.aqi,
    required this.trend,
    required this.color,
    required this.trendColor,
  });
}

// --- Health Impact Analysis Section ---
class HealthImpactAnalysisCard extends StatelessWidget {
  const HealthImpactAnalysisCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade900
            : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          if (Theme.of(context).brightness == Brightness.light)
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Health Impact Analysis',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.favorite, color: Colors.red, size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Risk Level',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          'High for Sensitive Groups',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 120),
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("View Details tapped")),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        elevation: 0,
                      ),
                      child: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'View Details',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 18),
          _HealthInfoTile(
            icon: Icons.groups_2_rounded,
            iconColor: Colors.red,
            title: 'Sensitive Groups',
            description:
                'Children, elderly, and individuals with respiratory conditions are at highest risk.',
            bgColor: Colors.red.shade50,
          ),
          const SizedBox(height: 10),
          _HealthInfoTile(
            icon: Icons.access_time_rounded,
            iconColor: Colors.orange,
            title: 'Exposure Duration',
            description:
                'Prolonged exposure (4+ hours) significantly increases health risks.',
            bgColor: Colors.orange.shade50,
          ),
          const SizedBox(height: 10),
          _HealthInfoTile(
            icon: Icons.check_circle_rounded,
            iconColor: Colors.green,
            title: 'Recommended Actions',
            description:
                'Limit outdoor activities, use air purifiers indoors, and wear N95 masks when outside.',
            bgColor: Colors.green.shade50,
          ),
        ],
      ),
    );
  }
}

class _HealthInfoTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final Color bgColor;

  const _HealthInfoTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
