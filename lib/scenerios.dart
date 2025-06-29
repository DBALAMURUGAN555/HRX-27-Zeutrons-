import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String baseURL = 'https://pollutionviz-3hta.onrender.com';

// Recommendation lists (10 sets of 3 recommendations each)
final List<List<String>> doRecommendations = [
  ["Wear N95 masks outdoors", "Use air purifiers", "Keep windows closed"],
  [
    "Check air quality index",
    "Stay indoors during peaks",
    "Hydrate frequently",
  ],
  [
    "Use saline nasal rinses",
    "Wash face after outdoors",
    "Shower after exposure",
  ],
  ["Create clean air rooms", "Use HEPA filters", "Wet-clean surfaces"],
  ["Monitor pollution forecasts", "Seal home openings", "Use indoor plants"],
  [
    "Wear protective eyewear",
    "Change clothes after outdoors",
    "Use humidifiers",
  ],
  [
    "Keep medications handy",
    "Install window filters",
    "Avoid peak pollution hours",
  ],
  [
    "Use antioxidant-rich diet",
    "Practice breathing exercises",
    "Maintain hydration",
  ],
  [
    "Wear full-sleeve clothing",
    "Use air quality apps",
    "Create safe zones at home",
  ],
  [
    "Wash fruits thoroughly",
    "Use nasal filters",
    "Keep emergency contacts ready",
  ],
];

final List<List<String>> dontRecommendations = [
  ["Avoid outdoor exercise", "Don't burn materials", "No smoking indoors"],
  ["Skip outdoor drying", "Avoid congested areas", "Don't use fireplaces"],
  ["Don't neglect symptoms", "Avoid dusty areas", "No candle burning"],
  ["Don't idle vehicles", "Avoid peak traffic", "No outdoor cooking"],
  [
    "Don't use wood stoves",
    "Avoid open windows at night",
    "No vigorous activities",
  ],
  ["Don't rub eyes outdoors", "Avoid polluted areas", "No incense sticks"],
  ["Don't ignore air alerts", "Avoid morning walks", "No diesel generators"],
  ["Don't use hairsprays", "Avoid pesticide sprays", "No burning garbage"],
  ["Don't skip medications", "Avoid construction sites", "No fireworks"],
  [
    "Don't use strong cleaners",
    "Avoid pet outdoor time",
    "No aerosol products",
  ],
];

final List<List<String>> minimizeRecommendations = [
  ["Reduce vehicle use", "Limit outdoor time", "Postpone activities"],
  ["Use public transport", "Combine errands", "Work from home"],
  [
    "Choose less busy routes",
    "Avoid rush hours",
    "Teleconference when possible",
  ],
  ["Conserve electricity", "Reduce AC usage", "Limit generator use"],
  ["Cut down fireplace use", "Minimize outdoor events", "Reduce dust creation"],
  [
    "Limit industrial area visits",
    "Decrease plastic burning",
    "Shorten shower time",
  ],
  ["Reduce lawn mowing", "Minimize printer use", "Lower vacuuming frequency"],
  [
    "Decrease aerosol products",
    "Limit barbecue grilling",
    "Reduce idling time",
  ],
  ["Minimize chemical cleaners", "Cut back on painting", "Lower solvent use"],
  ["Reduce candle usage", "Limit fireworks", "Decrease bonfire activities"],
];

class ScenariosPage extends StatefulWidget {
  const ScenariosPage({super.key});

  @override
  State<ScenariosPage> createState() => _ScenariosPageState();
}

class _ScenariosPageState extends State<ScenariosPage> {
  late Future<List<dynamic>> _scenariosData;
  late Future<Map<String, dynamic>> _recommendedActions;
  String _errorMessage = '';
  bool _actionsExpanded = false;
  int _retryCount = 0;
  final int _maxRetries = 3;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _retryCount = 0;
      _scenariosData = _fetchScenariosData();
      _recommendedActions = _fetchRecommendedActions();
      _errorMessage = '';
    });
  }

  Future<List<dynamic>> _fetchScenariosData() async {
    try {
      final response = await http
          .get(Uri.parse('$baseURL/get_scenario_presets'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          return data;
        } else {
          throw Exception('Expected list but got ${data.runtimeType}');
        }
      } else {
        throw Exception('Failed to load scenarios: ${response.statusCode}');
      }
    } catch (e) {
      if (_retryCount < _maxRetries) {
        _retryCount++;
        await Future.delayed(const Duration(seconds: 1));
        return _fetchScenariosData();
      } else {
        throw Exception('Failed after $_maxRetries attempts: $e');
      }
    }
  }

  Future<Map<String, dynamic>> _fetchRecommendedActions() async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseURL/citizen_actions'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 307) {
        final redirectUrl = response.headers['location'];
        if (redirectUrl != null) {
          final redirectedResponse = await http
              .post(
                Uri.parse(redirectUrl),
                headers: {'Content-Type': 'application/json'},
              )
              .timeout(const Duration(seconds: 10));

          if (redirectedResponse.statusCode == 200) {
            return json.decode(redirectedResponse.body);
          }
          throw Exception('Redirect failed: ${redirectedResponse.statusCode}');
        }
        throw Exception('No redirect location provided');
      } else {
        throw Exception('Failed with status: ${response.statusCode}');
      }
    } catch (e) {
      return getRandomRecommendations();
    }
  }

  Map<String, dynamic> getRandomRecommendations() {
    final random = Random();

    // Function to get 3 unique random items from a category
    List<String> getThreeRandomItems(List<List<String>> category) {
      final items = <String>{};
      while (items.length < 3) {
        final randomMainIndex = random.nextInt(category.length);
        final randomSubIndex = random.nextInt(category[randomMainIndex].length);
        items.add(category[randomMainIndex][randomSubIndex]);
      }
      return items.toList();
    }

    return {
      "do": getThreeRandomItems(doRecommendations),
      "dont": getThreeRandomItems(dontRecommendations),
      "minimize": getThreeRandomItems(minimizeRecommendations),
    };
  }

  Color _getAqiColor(String aqiLabel) {
    final label = aqiLabel.toLowerCase();
    if (label.contains('good')) return Colors.green;
    if (label.contains('moderate')) return Colors.yellow;
    if (label.contains('unhealthy for sensitive')) return Colors.orange;
    if (label.contains('unhealthy')) return Colors.red;
    if (label.contains('very unhealthy')) return Colors.purple;
    if (label.contains('hazardous')) return Colors.deepPurple.shade900;
    return Colors.grey;
  }

  Widget _buildPollutantRiskChips(List<dynamic> pollutants, bool isDark) {
    if (pollutants.isEmpty) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning, size: 20, color: Colors.red.shade800),
              const SizedBox(width: 8),
              Text(
                'Pollutant Risks',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.red.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: pollutants.map<Widget>((p) {
              final increase = p['increase_percent']?.toDouble() ?? 0.0;
              final pollutantName = p['pollutant']?.toString() ?? 'Unknown';
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[700] : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.red.shade100),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      pollutantName,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      '+${increase.toStringAsFixed(1)}%',
                      style: GoogleFonts.montserrat(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
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

  Widget _buildInfoSection(
    String title,
    List<dynamic> items,
    Color color,
    IconData icon,
    bool isDark,
  ) {
    if (items.isEmpty) return const SizedBox();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? color.withOpacity(0.1) : color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(isDark ? 0.3 : 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6, right: 10),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item.toString(),
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: isDark ? Colors.white : Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildScenarioCard(
    Map<String, dynamic> scenario,
    BuildContext context,
  ) {
    final pollutants = scenario['top_pollutant_risks'] ?? [];
    final healthRisks = scenario['health_risks'] ?? [];
    final sources = scenario['main_sources'] ?? [];
    final aqiLabel = scenario['aqi_label']?.toString() ?? 'Unknown';
    final location = "Nagpur";
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? Colors.grey[850] : Colors.grey[50];

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          width: 0.5,
        ),
      ),
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              scenario['name']?.toString() ?? 'Unnamed Scenario',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: isDark ? Colors.white : Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 16,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
                const SizedBox(width: 6),
                Text(
                  location,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getAqiColor(
                      aqiLabel,
                    ).withOpacity(isDark ? 0.8 : 0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    aqiLabel,
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              scenario['description'] ?? 'No description available',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: isDark ? Colors.grey[300] : Colors.grey[700],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                _buildPollutantRiskChips(pollutants, isDark),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          if (sources.isNotEmpty)
                            _buildInfoSection(
                              'Main Sources',
                              sources,
                              Colors.orange,
                              Icons.local_shipping,
                              isDark,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        children: [
                          if (healthRisks.isNotEmpty)
                            _buildInfoSection(
                              'Health Risks',
                              healthRisks,
                              Colors.red,
                              Icons.medical_services,
                              isDark,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 24, thickness: 0.5),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Updated: ${DateTime.now().toString().substring(0, 10)}',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: isDark ? Colors.grey[500] : Colors.grey[400],
                    ),
                  ),
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: isDark ? Colors.grey[500] : Colors.grey[400],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedActionsPanel(
    Map<String, dynamic>? actions,
    BuildContext context,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final doList = actions?['do'] as List? ?? [];
    final dontList = actions?['dont'] as List? ?? [];
    final minimizeList = actions?['minimize'] as List? ?? [];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[850] : Colors.blue.shade50,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              'Recommended Actions',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: isDark ? Colors.white : Colors.blue.shade800,
              ),
            ),
            trailing: Icon(
              _actionsExpanded ? Icons.expand_less : Icons.expand_more,
              color: isDark ? Colors.white : Colors.blue.shade800,
            ),
            onTap: () {
              setState(() {
                _actionsExpanded = !_actionsExpanded;
              });
            },
          ),
          if (_actionsExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  if (doList.isNotEmpty)
                    _buildActionSection(
                      'Recommended Actions',
                      doList,
                      Colors.green,
                      Icons.check_circle_outline,
                      isDark,
                    ),
                  if (dontList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: _buildActionSection(
                        'Actions to Avoid',
                        dontList,
                        Colors.red,
                        Icons.highlight_off,
                        isDark,
                      ),
                    ),
                  if (minimizeList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: _buildActionSection(
                        'Actions to Minimize',
                        minimizeList,
                        Colors.orange,
                        Icons.reduce_capacity,
                        isDark,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionSection(
    String title,
    List<dynamic> items,
    Color color,
    IconData icon,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? color.withOpacity(0.1) : color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(isDark ? 0.3 : 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6, right: 10),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item.toString(),
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: isDark ? Colors.white : Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pollution Scenarios',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 22),
            onPressed: _loadData,
            tooltip: 'Refresh data',
          ),
        ],
      ),
      body: Stack(
        children: [
          FutureBuilder<List<dynamic>>(
            future: _scenariosData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Loading pollution scenarios...',
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (_errorMessage.isNotEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, color: Colors.red, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage,
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _loadData,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Try Again',
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (snapshot.data == null || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    'No scenarios available',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  _loadData();
                },
                color: Theme.of(context).primaryColor,
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return _buildScenarioCard(snapshot.data![index], context);
                  },
                ),
              );
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FutureBuilder<Map<String, dynamic>>(
              future: _recommendedActions,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[850] : Colors.blue.shade50,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: const Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[850] : Colors.blue.shade50,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Failed to load actions',
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            color: Colors.red,
                          ),
                        ),
                        TextButton(
                          onPressed: _loadData,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                return _buildRecommendedActionsPanel(snapshot.data, context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
