import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PollutionVIZ',
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.dark,
      ),
      home: const ChatbotPage(onToggleTheme: null, isDarkMode: false),
    );
  }
}

class ChatbotPage extends StatefulWidget {
  final VoidCallback? onToggleTheme;
  final bool isDarkMode;
  const ChatbotPage({
    super.key,
    required this.onToggleTheme,
    required this.isDarkMode,
  });

  @override
  State<ChatbotPage> createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final List<String> _tabs = [
    "Help",
    "Compare Locations",
    "Health Risks",
    "Policy Tips",
    "Fun Facts",
    "Myth Buster",
  ];
  int _selectedTab = 0;
  final TextEditingController _controller = TextEditingController();
  bool _isSearching = false;
  String _response =
      "Hello! I'm Clarity, your pollution awareness assistant. How can I help you today?";
  final String _apiUrl = "https://pollutionviz-3hta.onrender.com/asking";

  void _onTabSelected(int index) {
    setState(() {
      _selectedTab = index;
      _response = "You selected ${_tabs[index]}. What would you like to know?";
    });
  }

  Future<void> _onSearch() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _isSearching = true;
      _response = "Processing...";
    });

    try {
      final response = await http.get(
        Uri.parse(
          "$_apiUrl?prompt=${Uri.encodeComponent(_controller.text.trim())}",
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          _response = response.body;
          _isSearching = false;
          _controller.clear();
        });
      } else {
        setState(() {
          _response = "Error ${response.statusCode}: ${response.body}";
          _isSearching = false;
        });
      }
    } catch (e) {
      setState(() {
        _response = "Error: $e";
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Row(
            children: [
              const FlutterLogo(size: 28),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  'PollutionVIZ',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            tooltip: 'Toggle Theme',
            onPressed: widget.onToggleTheme,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _ChatbotBody(
        tabs: _tabs,
        selectedTab: _selectedTab,
        onTabSelected: _onTabSelected,
        controller: _controller,
        onSearch: _onSearch,
        isSearching: _isSearching,
        response: _response,
        isDark: isDark,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: isDark ? Colors.white : Colors.green,
        unselectedItemColor: isDark ? const Color(0xFFB0B3B8) : Colors.black54,
        backgroundColor: isDark ? const Color(0xFF23242B) : Colors.white,
        onTap: (_) {},
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Insights',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_in_ar),
            label: 'Scenarios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(fontFamily: 'Montserrat'),
      ),
    );
  }
}

class _ChatbotBody extends StatelessWidget {
  final List<String> tabs;
  final int selectedTab;
  final ValueChanged<int> onTabSelected;
  final TextEditingController controller;
  final VoidCallback onSearch;
  final bool isSearching;
  final String response;
  final bool isDark;

  const _ChatbotBody({
    required this.tabs,
    required this.selectedTab,
    required this.onTabSelected,
    required this.controller,
    required this.onSearch,
    required this.isSearching,
    required this.response,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 32),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF2DE3A7)
                        : Colors.green.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.smart_toy_rounded,
                    color: isDark ? Colors.white : Colors.green,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Clarity",
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Your pollution awareness assistant",
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 18),
                // Tabs
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      tabs.length,
                      (i) => GestureDetector(
                        onTap: () => onTabSelected(i),
                        child: _ChatTab(
                          label: tabs[i],
                          selected: i == selectedTab,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 3,
                  width: 80,
                  margin: const EdgeInsets.only(left: 8),
                  color: isDark ? Colors.greenAccent : Colors.green,
                ),
                const SizedBox(height: 18),
                // Chat bubble
                Container(
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth < 340
                        ? constraints.maxWidth - 32
                        : 340,
                  ),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF23242B) : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      if (!isDark)
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                  child: isSearching
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: isDark
                                    ? Colors.greenAccent
                                    : Colors.green,
                                strokeWidth: 3,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "Searching...",
                              style: GoogleFonts.montserrat(
                                fontSize: 15,
                                color: isDark ? Colors.white70 : Colors.black87,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          response,
                          style: GoogleFonts.montserrat(
                            fontSize: 15,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                ),
                const SizedBox(height: 18),
                // Input
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: constraints.maxWidth < 340
                          ? constraints.maxWidth - 32
                          : 340,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF23242B) : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          if (!isDark)
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller,
                              minLines: 1,
                              maxLines: 4,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Ask me about pollution...",
                                hintStyle: GoogleFonts.montserrat(
                                  color: isDark ? Colors.white54 : Colors.grey,
                                ),
                                isCollapsed: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                              ),
                              style: GoogleFonts.montserrat(
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                              onSubmitted: (_) => onSearch(),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF2DE3A7)
                                  : Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                              ),
                              onPressed: onSearch,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ChatTab extends StatelessWidget {
  final String label;
  final bool selected;
  const _ChatTab({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: selected
            ? (isDark ? const Color(0xFF2DE3A7) : Colors.green)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: GoogleFonts.montserrat(
          color: selected
              ? Colors.white
              : (isDark ? Colors.white70 : Colors.black87),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
